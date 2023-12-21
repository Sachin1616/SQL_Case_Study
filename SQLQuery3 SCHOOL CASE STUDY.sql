CREATE DATABASE School;
USE School;

CREATE TABLE CourseMaster 
(
CID INT PRIMARY KEY,
COURSENAME VARCHAR(40) NOT NULL,
Category CHAR(1) NULL CHECK (Category IN ('B', 'M', 'A')),
FEE SMALLMONEY NOT NULL CHECK (FEE>0)
);


CREATE TABLE StudentMaster
(
SID TINYINT PRIMARY KEY,
studentName VARCHAR(40) NOT NULL,
origin CHAR(1) NOT NULL CHECK (origin IN ('L','F')),
type CHAR(1) NOT NULL CHECK (type IN ('U','G'))
);

CREATE TABLE EnrollmentMaster 
(
CID INT NOT NULL,
SID TINYINT NOT NULL,
DOE DATETIME NOT NULL,
FWF BIT NOT NULL,
grade CHAR(1) CHECK (grade IN ('O','A','B','C')),
PRIMARY KEY (CID, SID),
FOREIGN KEY (CID) REFERENCES CourseMaster (CID),
FOREIGN KEY (SID) REFERENCES StudentMaster (SID)
);

INSERT INTO CourseMaster
VALUES
(1,'PYTHON', 'B',8000),
(2,'AZURE', 'A',10000),
(3,'TESTING', 'M',5000),
(4,'PYTHON', 'A',8000),
(5,'SQL', 'B',3000),
(6,'DEVOPS', 'B',15000),
(7,'PYTHON', 'M',8000),
(8,'AZURE', 'B',10000),
(9,'CLOUD', 'B',20000),
(10,'AZURE', 'M',10000);

INSERT INTO StudentMaster
VALUES
(101,'Sachin','L','G'),
(102,'Hema','L','U'),
(103,'Krishna','F','G'),
(104,'Chaithu','L','U'),
(105,'Harshdeep','F','U'),
(106,'Geol','F','G'),
(107,'Prateek','F','U'),
(108,'Anjali','L','G'),
(109,'Jeevan','L','U'),
(110,'Divyesh','L','G');

INSERT INTO EnrollmentMaster
VALUES
(1,101, '2023-01-15 15:30:00',0,'A'),
(2,109, '2022-06-25 10:30:00',0,'B'),
(3,107, '2023-09-15 17:30:00',1,'C'),
(4,102, '2023-07-08 11:25:12',0,'A'),
(5,104, '2023-08-19 12:30:00',0,'O'),
(6,103, '2022-05-12 14:30:00',1,'A'),
(7,106, '2022-04-14 12:30:00',0,'B'),
(8,108, '2022-08-13 08:30:00',1,'C'),
(9,105, '2023-09-16 09:30:00',0,'C'),
(10,109, '2022-02-18 13:30:00',1,'O');

--Q1
SELECT CourseMaster.COURSENAME, COUNT(EnrollmentMaster.SID) AS Total_Students_Enrolled
FROM CourseMaster 
JOIN EnrollmentMaster  ON CourseMaster.CID = EnrollmentMaster.CID
JOIN StudentMaster  ON EnrollmentMaster.SID = StudentMaster.SID
WHERE StudentMaster.origin = 'F'
GROUP BY CourseMaster.COURSENAME
HAVING COUNT(EnrollmentMaster.SID) > 10;

--Q2 
SELECT StudentMaster.studentName
FROM StudentMaster 
WHERE NOT EXISTS (
    SELECT 1
    FROM EnrollmentMaster 
    INNER JOIN CourseMaster  ON EnrollmentMaster.CID = CourseMaster.CID
    WHERE EnrollmentMaster.SID = StudentMaster.SID
    AND CourseMaster.COURSENAME = 'JAVA'
);

--Q3
SELECT CourseMaster.COURSENAME, COUNT(EnrollmentMaster.SID) AS Foreign_Student_Enrollment
FROM CourseMaster 
JOIN EnrollmentMaster ON CourseMaster.CID = EnrollmentMaster.CID
JOIN StudentMaster ON EnrollmentMaster.SID = StudentMaster.SID
WHERE CourseMaster.Category = 'M' AND StudentMaster.origin = 'F'
GROUP BY CourseMaster.COURSENAME
ORDER BY COUNT(EnrollmentMaster.SID) DESC;

--Q4
USE School;

SELECT DISTINCT StudentMaster.studentName
FROM StudentMaster 
INNER JOIN EnrollmentMaster ON StudentMaster.SID = EnrollmentMaster.SID
INNER JOIN CourseMaster ON EnrollmentMaster.CID = CourseMaster.CID
WHERE CourseMaster.Category = 'B' 
AND MONTH(EnrollmentMaster.DOE) = MONTH(GETDATE());

--Q5
SELECT StudentMaster.studentName
FROM EnrollmentMaster
INNER JOIN StudentMaster ON EnrollmentMaster.SID = StudentMaster.SID
INNER JOIN CourseMaster ON EnrollmentMaster.CID = CourseMaster.CID
WHERE StudentMaster.type = 'U'
  AND StudentMaster.origin = 'L'
  AND CourseMaster.Category = 'B'
  AND EnrollmentMaster.grade = 'C';

--Q6
SELECT CourseMaster.CourseName FROM CourseMaster 
WHERE NOT EXISTS 
(
SELECT 1
FROM EnrollmentMaster 
WHERE CourseMaster.CID = EnrollmentMaster.CID
AND MONTH(EnrollmentMaster.DOE) = 5
AND YEAR(EnrollmentMaster.DOE) = 2020
);

--Q7
SELECT CourseMaster.COURSENAME AS 'Course Name',
COUNT(EnrollmentMaster.CID) AS 'Number of Enrollments',
 CASE 
    WHEN COUNT(EnrollmentMaster.CID) > 50 THEN 'High'
    WHEN COUNT(EnrollmentMaster.CID) >= 20 AND COUNT(EnrollmentMaster.CID) <= 50 THEN 'Medium'
       ELSE 'Low'
    END AS 'Popularity'
FROM CourseMaster 
LEFT JOIN EnrollmentMaster  ON CourseMaster.CID = EnrollmentMaster.CID
GROUP BY CourseMaster.COURSENAME
ORDER BY COUNT(EnrollmentMaster.CID) DESC;

--Q8
SELECT StudentMaster.studentName AS 'Student Name',
CourseMaster.COURSENAME AS 'Course Name',
DATEDIFF(DAY, EnrollmentMaster.DOE, GETDATE()) AS 'Age of Enrollment (Days)'
FROM EnrollmentMaster
INNER JOIN StudentMaster ON EnrollmentMaster.SID = StudentMaster.SID
INNER JOIN CourseMaster ON EnrollmentMaster.CID = CourseMaster.CID
WHERE EnrollmentMaster.DOE = (SELECT MAX(DOE) FROM EnrollmentMaster WHERE SID = EnrollmentMaster.SID)

--Q9
SELECT StudentMaster.studentName
FROM StudentMaster 
JOIN EnrollmentMaster ON StudentMaster.SID = EnrollmentMaster.SID
JOIN CourseMaster ON EnrollmentMaster.CID = CourseMaster.CID
WHERE StudentMaster.origin = 'L' AND CourseMaster.Category = 'B'
GROUP BY StudentMaster.SID, StudentMaster.studentName
HAVING COUNT(*) = 3;

--Q10
SELECT CourseMaster.CourseName
FROM CourseMaster 
WHERE 
NOT EXISTS
(
  SELECT 1
  FROM StudentMaster 
  WHERE NOT EXISTS
  (SELECT 1
  FROM EnrollmentMaster 
  WHERE EnrollmentMaster.CID = CourseMaster.CID AND EnrollmentMaster.SID = StudentMaster.SID)
);

--Q11
SELECT StudentMaster.studentName
FROM EnrollmentMaster
INNER JOIN StudentMaster ON EnrollmentMaster.SID = StudentMaster.SID
WHERE EnrollmentMaster.grade = 'O' AND EnrollmentMaster.FWF = 1;

--Q12
SELECT StudentMaster.studentName
FROM StudentMaster 
INNER JOIN EnrollmentMaster ON StudentMaster.SID = EnrollmentMaster.SID
INNER JOIN CourseMaster ON EnrollmentMaster.CID = CourseMaster.CID
WHERE StudentMaster.origin = 'F'
AND StudentMaster.type = 'U'
AND CourseMaster.Category = 'B'
AND EnrollmentMaster.grade = 'C';

--Q13
SELECT CourseMaster.COURSENAME, COUNT(EnrollmentMaster.CID) AS TotalEnrollments
FROM CourseMaster 
INNER JOIN EnrollmentMaster ON CourseMaster.CID = EnrollmentMaster.CID
WHERE MONTH(EnrollmentMaster.DOE) = MONTH(GETDATE()) AND YEAR(EnrollmentMaster.DOE) = YEAR(GETDATE())
GROUP BY CourseMaster.COURSENAME;








