import React from 'react';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import ShoppingCartPage from './pages/shoppingCartPage';
import SwipePage from './pages/swipePage';
import HomePage from './pages/homePage';

const App = () => {
  return (
    <Router>
      <div className='App'>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/shoppingcart" element={<ShoppingCartPage />} />
          <Route path="/swipe" element={<SwipePage />} />
        </Routes>
      </div>
    </Router>
  )
}

export default App;