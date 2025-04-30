import React from "react";
import NavBar from "../components/navBar";
import ClassCard from "../components/classCard";
import "bootstrap/dist/css/bootstrap.min.css";

const ShoppingCartPage = () => {
  return (
    <>
      <NavBar />
      <div className="container-fluid py-5">
        <h1 className="mb-4 text-center text-primary fw-bold">My Cart</h1>

        <ClassCard
            course={{
                name: "Intro to Computer Programming",
                course_number: "COMP_SCI 110",
                description:
                "Introduction to programming practice using Python. Analysis and formulation of problems for computer solution. Systematic design, construction, and testing of programs. Substantial programming assignments in Python. This introductory programming course is not part of the major. It provides an introduction to programming for those that can benefit from becoming better programmers, but without committing to the major student's version of the course.",
                instructors: [
                { name: "Anastasia Kurdia", email: "anastasia.kurdia@northwestern.edu" },
                { name: "Dietrich Geisler", email: "dietrich.geisler@northwestern.edu" },
                { name: "Ian Horswill", email: "ian.horswill@northwestern.edu" },
                ],
                labels: [
                { name: "racket", display_name: "Racket" },
                { name: "required", display_name: "Required" },
                { name: "systems", display_name: "Systems" },
                { name: "time_consuming", display_name: "Time Consuming" },
                ],
            }}
        />
        <ClassCard
            course={{
                name: "Intro to Computer Programming",
                course_number: "COMP_SCI 110",
                description:
                "Introduction to programming practice using Python. Analysis and formulation of problems for computer solution. Systematic design, construction, and testing of programs. Substantial programming assignments in Python. This introductory programming course is not part of the major. It provides an introduction to programming for those that can benefit from becoming better programmers, but without committing to the major student's version of the course.",
                instructors: [
                { name: "Anastasia Kurdia", email: "anastasia.kurdia@northwestern.edu" },
                { name: "Dietrich Geisler", email: "dietrich.geisler@northwestern.edu" },
                { name: "Ian Horswill", email: "ian.horswill@northwestern.edu" },
                ],
                labels: [
                { name: "racket", display_name: "Racket" },
                { name: "required", display_name: "Required" },
                { name: "systems", display_name: "Systems" },
                { name: "time_consuming", display_name: "Time Consuming" },
                ],
            }}
        />
      </div>
    </>
  );
};

export default ShoppingCartPage;
