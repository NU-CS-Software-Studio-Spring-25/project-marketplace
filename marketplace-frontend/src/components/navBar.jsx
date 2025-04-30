import React from "react";
import { Link } from "react-router-dom";

const NavBar = () => {
  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light px-4 w-100">
      <div className="container-fluid">
        <Link className="navbar-brand fw-bold text-primary" to="/">
          cs class marketplace
        </Link>
        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
        >
          <span className="navbar-toggler-icon"></span>
        </button>

        <div className="collapse navbar-collapse" id="navbarNav">
          <ul className="navbar-nav ms-auto">
            <li className="nav-item">
              <Link className="nav-link" to="/">home</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/shoppingcart">my cart</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/swipe">swipe</Link>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
