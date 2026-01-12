import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    # Get user's stocks
    user_id = session["user_id"]
    stocks = db.execute(
        "SELECT symbol, SUM(shares) as total_shares FROM transections WHERE user_id = ? GROUP BY symbol HAVING total_shares > 0", user_id)

    # Get user's balance
    cash = db.execute("SELECT cash FROM users WHERE id = ?", user_id)[0]["cash"]

    # Total value
    total_value = cash

    for stock in stocks:
        quote = lookup(stock["symbol"])
        stock["name"] = quote["name"]
        stock["price"] = quote["price"]
        stock["value"] = quote["price"] * stock["total_shares"]
        total_value += stock["value"]

    return render_template("index.html", stocks=stocks, cash=usd(cash), total_value=usd(total_value))


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""

    if request.method == "POST":
        symbol = request.form.get("symbol").upper()
        shares = request.form.get("shares")
        if not symbol:
            return apology("Symbol is required")
        elif not (shares and shares.isdigit() and int(shares) > 0):
            return apology("Invalid amount of  shares")

        quote = lookup(symbol)
        if quote is None:
            return apology("Symbol not found")

        price = quote["price"]
        total_cost = int(shares) * price
        user_id = session["user_id"]
        cash = db.execute("SELECT cash FROM users WHERE id = ?", user_id)[0]["cash"]

        if cash < total_cost:
            return apology("You don't have enough cash")

        # Update database
        db.execute("UPDATE users SET cash = cash - ? WHERE id = ?", total_cost, user_id)

        # Update history
        db.execute("INSERT INTO transections (user_id, symbol, shares, price) VALUES (?, ?, ?, ?)",
                   user_id, symbol, shares, price)

        flash(f"Bought {shares} shares of {symbol} costing {usd(total_cost)}!")
        return redirect("/")

    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transections"""

    user_id = session["user_id"]
    transections = db.execute(
        "SELECT * FROM transections WHERE user_id = ? ORDER BY timestamp DESC", user_id)

    return render_template("history.html", transections=transections)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    if request.method == "POST":
        symbol = request.form.get("symbol").upper()
        quote = lookup(symbol)
        if not quote:
            return apology("Invalid symbol", 400)
        else:
            return render_template("quote.html", quote=quote)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # Clear previous session
    session.clear()

    # Defining variables
    username = request.form.get("username")
    password = request.form.get("password")
    confirm = request.form.get("confirmation")

    if request.method == "POST":
        if not username:
            return apology("Username is required", 400)
        elif not password:
            return apology("Password is required", 400)
        elif not confirm:
            return apology("You must confirm your password is required")
        elif password != confirm:
            return apology("Your password didn't match with confirm password", 400)

        # Search database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", username)

        # Check for existing user
        if len(rows) != 0:
            return apology("This user already exist", 400)

        # Register new user
        db.execute("INSERT INTO users (username, hash) VALUES (?, ?)",
                   username, generate_password_hash(password))

        # Search for new user
        id = db.execute("SELECT id FROM users WHERE username = ?", username)[0]["id"]

        # Auto login as new user
        session["user_id"] = id
        return redirect("/")

    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # Get user's stocks
    user_id = session["user_id"]
    stocks = db.execute(
        "SELECT symbol, SUM(shares) as total_shares FROM transections WHERE user_id = ? GROUP BY symbol HAVING total_shares > 0", user_id)

    if request.method == "POST":
        symbol = request.form.get("symbol").upper()
        shares = request.form.get("shares")

        if not symbol:
            return apology("Symbol is required")
        elif not (shares and shares.isdigit() and int(shares) > 0):
            return apology("Invalid amount of shares")

        for stock in stocks:
            if stock["symbol"] == symbol:
                if stock["total_shares"] < int(shares):
                    return apology("You don't have enough shares")
                else:
                    quote = lookup(symbol)
                    if quote is None:
                        return apology("Symbol not found")

                    price = quote["price"]
                    total_sale = int(shares) * price

                    # Update user
                    db.execute("UPDATE users SET cash = cash + ? WHERE id = ?", total_sale, user_id)

                    # Update history
                    db.execute("INSERT INTO transections (user_id, symbol, shares, price) VALUES (?, ?, ?, ?)",
                               user_id, symbol, -(int(shares)), price)

                    flash(f"Sold {shares} shares of {symbol} for {usd(total_sale)}!")
                    return redirect("/")
        return apology("Symbol not found")
    else:
        return render_template("sell.html", stocks=stocks)
