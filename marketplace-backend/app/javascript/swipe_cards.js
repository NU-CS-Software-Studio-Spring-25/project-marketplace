document.addEventListener("turbo:load", () => {
  const cards = document.querySelectorAll(".swipe-card");
  let currentIndex = 0;

  function showNextCard() {
    console.log("showNextCard called, currentIndex:", currentIndex);
    if (currentIndex < cards.length) {
      // Add exit animation class
      cards[currentIndex].classList.add("swipe-card-exit-active");
      
      setTimeout(() => {
        cards[currentIndex].classList.add("d-none");
        currentIndex++;
        
        if (currentIndex < cards.length) {
          cards[currentIndex].classList.remove("d-none");
          // Add entrance animation class
          cards[currentIndex].classList.add("swipe-card-enter-active");
          
          // Remove animation classes after animation completes
          setTimeout(() => {
            cards[currentIndex].classList.remove("swipe-card-enter-active");
          }, 300);
        } else {
          const coursesPath = document.querySelector('meta[name="courses-path"]')?.content || '/courses';
          document.getElementById("swipes-card-container").innerHTML = `
            <div class="no-more-courses">
              <h3>No more courses to swipe</h3>
              <p>Check back later for more academic matches or explore our course catalog.</p>
              <a href="${coursesPath}" class="btn-hinge-primary mt-3">Browse All Courses</a>
            </div>
          `;
        }
      }, 300);
    }
  }

  // Use event delegation on the document body to catch all clicks
  document.body.addEventListener("click", function(e) {
    console.log("Click detected on:", e.target, "Classes:", e.target.className);
    
    // Check if the clicked element or its parent is a skip button
    const skipButton = e.target.closest(".skip-button");
    if (skipButton) {
      console.log("Skip button clicked!");
      e.preventDefault();
      e.stopPropagation();
      showNextCard();
      return;
    }
  });

  // Use event delegation for form submissions
  document.body.addEventListener("submit", function(e) {
    console.log("Form submit detected on:", e.target);
    
    const saveForm = e.target.closest(".save-form");
    if (saveForm) {
      console.log("Save form submitted!");
      setTimeout(() => showNextCard(), 100);
    }
  });

  console.log("Swipe cards JavaScript loaded. Found", cards.length, "cards");
}); 