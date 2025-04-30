import React from "react";
import { v4 as uuidv4 } from "uuid";
import "bootstrap/dist/css/bootstrap.min.css";

const ClassCard = ({ course }) => {
  return (
    <div className="card shadow-sm p-4 mb-4 border-0 rounded-4">
      <h3 className="text-primary">{course.name}</h3>
      <h5 className="text-muted mb-3">{course.course_number}</h5>

      <div className="mb-3">
        <h6 className="fw-bold">Instructors</h6>
        <div className="d-flex flex-wrap gap-2">
          {course.instructors?.map((instructor) => (
            <span
              key={uuidv4()}
              className="btn btn-outline-secondary rounded-pill px-3 py-1"
              style={{ pointerEvents: "none", transition: "0.2s" }}
            >
              {instructor.name}
            </span>
          ))}
        </div>
      </div>

      <div>
        <h6 className="fw-bold">Labels</h6>
        <div className="d-flex flex-wrap gap-2">
          {course.labels?.map((label) => (
            <span
              key={uuidv4()}
              className="btn btn-outline-primary rounded-pill px-3 py-1"
              style={{ pointerEvents: "none", transition: "0.2s" }}
            >
              {label.display_name}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ClassCard;
