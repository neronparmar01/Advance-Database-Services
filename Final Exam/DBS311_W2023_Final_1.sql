-- -------------------------------
-- DBS311 - Fall 2023 
-- FINAL TEST - PART A PL/SQL
-- December 7, 2023
-- Total 15 Marks
-- -------------------------------

--Name: Neron Parmar
--Student Number: 171690217

--As a Seneca student, you must conduct yourself in an honest and
--trustworthy manner in all aspects of your academic career. 
--A dishonest attempt to obtain an academic advantage is considered
--an offense, and will not be tolerated by the College.

-- Answer the following questions in the uncommented space indicated below. For some questions you 
-- are given the code for and you must modify it, for others you must write the 
-- entire code yourself. Your script should run without any syntax errors.
--When you have completed both sections of the test, upload it to the the Final Test dropbox.

/* QUESTION 0
Write the code and execute it such that output will show in the script window.
(1 MARK) */
-- Answer 0 --
SELECT 'HELLO WORLD...!' AS OUTPUT FROM DUAL;


/* QUESTION 1
Using the following code, correct the code such that it runs and outputs your name!  There may or may
not be more than one correction to make!  Make sure you put YOUR name in the
code where specified (4 MARKS)
*/
CREATE OR REPLACE PROCEDURE spHelloWorld(MyName OUT varchar2)
IS 
BEGIN
    MyName := 'NERON PARMAR';
    DBMS_OUTPUT.PUT_LINE('Hello ' || MyName || '!');
END spHelloWorld;

BEGIN
    spHelloWorld('NERON PARMAR');
END;

/* QUESTION 2
Write a PL/SQL procedure spFutbol that accepts 2 integers and 2 strings, the 2 strings represent the homeTeam name
and visitTeam name, and 2 integers represent the scores for each team in the game.  The procedure will:
- determine which team won the match and display the team name of the winning team. 
- If the game was a tie (the two scores are the same) display both teams and "Tied Game"
- if an error occurs or the winner cannot be determined, display "Error - No result"
(5 MARKS)
*/
-- ANSWER 2 --
CREATE OR REPLACE PROCEDURE spFutbol(
    homeTeamName IN VARCHAR2,
    visitTeamName IN VARCHAR2,
    homeTeamScore IN NUMBER,
    visitTeamScore IN NUMBER
)
IS
BEGIN
    IF homeTeamScore > visitTeamScore THEN
        DBMS_OUTPUT.PUT_LINE(homeTeamName || ' won the match!');
    ELSIF homeTeamScore < visitTeamScore THEN
        DBMS_OUTPUT.PUT_LINE(visitTeamName || ' won the match!');
    ELSE
        DBMS_OUTPUT.PUT_LINE(homeTeamName || ' and ' || visitTeamName || ' Tied Game');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error - No result');
END spFutbol;
-- Execuion of answer 2 --
DECLARE
    homeTeam VARCHAR2(50) := 'TeamA';
    visitTeam VARCHAR2(50) := 'TeamB';
    homeScore NUMBER := 2;
    visitScore NUMBER := 1;
BEGIN
    spFutbol(homeTeam, visitTeam, homeScore, visitScore);
END;


/* QUESTION 3
Create a function named sfTAX that accepts a number as the total order amount and a province abbreviation to calculate the correct tax amount for the order. The tax is determined by the shipping province at the
following rates:
ON has a tax rate of 13%
PQ has a tax rate of 12%
AB has a tax rate of 8%
If the province isn’t provided a tax amount of zero should be applied to the order. 
Create the code to run the function and display the return value.
(5 MARKS)
*/
-- ANSWER 3 --
CREATE OR REPLACE FUNCTION sfTAX(
    totalOrderAmount IN NUMBER,
    provinceAbbreviation IN VARCHAR2
) RETURN NUMBER
IS
    taxRate NUMBER;
BEGIN
    CASE provinceAbbreviation
        WHEN 'ON' THEN
            taxRate := 0.13;
        WHEN 'PQ' THEN
            taxRate := 0.12;
        WHEN 'AB' THEN
            taxRate := 0.08;
        ELSE
            taxRate := 0; 
    END CASE;
    -- Calculating and returning the tax amount
    RETURN totalOrderAmount * taxRate;
END sfTAX;
-- Execution of the answer 3
DECLARE
    totalAmount NUMBER := 100.0;
    province VARCHAR2(2) := 'ON'; -- Replace with the desired province abbreviation
    taxAmount NUMBER;
BEGIN
    taxAmount := sfTAX(totalAmount, province);
    DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || taxAmount);
END;


/* --------------------------------------------------
DBS311 - W2023 Final Test - NoSQL MongoDB
Total 30 Marks

Name: Neron Parmar
Student Number: 171690217

--As a Seneca student, you must conduct yourself in an honest and
--trustworthy manner in all aspects of your academic career. 
--A dishonest attempt to obtain an academic advantage is considered
--an offense, and will not be tolerated by the College.

INSTRUCTIONS
Answer each question in the space provided.  Incorrectly formatted 
code will result in reduced marks. 
-------------------------------------------------- */




/* QUESTION 4
Connect to your mongodb using a NEW connectionstring.  
In the connectionstring, call the database F2023_FTest_yourusername
making sure to replace yourusername with your actual SENECA username 
(i.e. the leading part of your myseneca email address)
copy and paste your FULL connectionstring below (2 MARKS)
*/
-- ANSWER Q4 --
mongodb://nparmar22:<password>@hostname:port::1521/F2023_FTest_nparmar22


/* QUESTION 5
Using a collection, called "Customers", create ONE statement to add 
the following documents.  (make sure you use your own name for Customer 1)
[ { "_id":1,
     "Customer":{"fname":"<your first name>", 
                "lname":"<your last name>", 
                "Phone":"9055551212"},
     "orders":[1000,1001]},
  { "_id":2,
     "Customer":{"fname":"Jane", 
                "lname":"Smith", 
                "email":"jsmith@dom.com"},
     "orders":[2001,2002]},
  { "_id":3,
    "Customer":{"fname":"Raj", 
               "lname":"Patel", 
               "email":"rpatel@ema.com"}
  }
]   (3 MARKS)
*/
-- ANSWER 5 --
db.Customers.insertMany([
    {
        "_id": 1,
        "Customer": {"fname": "Neron", "lname": "Parmar", "Phone": "9055551212"},
        "orders": [1000, 1001]
    },
    {
        "_id": 2,
        "Customer": {"fname": "Jane", "lname": "Smith", "email": "jsmith@dom.com"},
        "orders": [2001, 2002]
    },
    {
        "_id": 3,
        "Customer": {"fname": "Raj", "lname": "Patel", "email": "rpatel@ema.com"}
    }
]);


/* QUESTION 6
Write the MongoDB command to add the order 2003 to the orders for Ms. Smith. (3 MARKS)
*/
-- ANSWER 6 --
db.Customers.update( {"Customer.fname": "Jane", "Customer.lname": "Smith"}, {$push: {"orders": 2003}});


/* QUESTION 7
Write the MongoDB command to return all customers who do not have an email address. (3 MARKS)
*/
-- ANSWER 7 --
db.Customers.find({"Customer.email": {$exists: false}});


/* QUESTION 8
Write the MongoDB code to add 3 documents to the "songs" collection.  
Use the ISRC number as the document identifying key value.  
Use the following information (note the 3rd song uses your name and student id#): 
(3 MARKS)
ISRC	            Title	          Author
----------------  --------------  ---------------
USSM15900115	  Blue In Green	  	Miles Davis
GBAAM0201175	  Walking on the Moon	The Police
<Your student ID> 	DBS311	        <Your Name>
*/
-- ANSWER 8 --
db.songs.insertMany([
    {"_id": "USSM15900115", "Title": "Blue In Green", "Author": "Miles Davis"},
    {"_id": "GBAAM0201175", "Title": "Walking on the Moon", "Author": "The Police"},
    {"_id": "171690217", "Title": "DBS311", "Author": "Neron"}
]);


/* QUESTION 9
Write the MongoDB command to modify the 1st document above to add 
the "Album" key to it with value "Kind of Blue". 
(3 MARKS)
*/
-- ANSWER 9 --
db.songs.update({"_id": "USSM15900115"}, {$set: {"Album": "Kind of Blue"}});


/* QUESTION 10
Write the MongoDB code to remove all song titles from the collection songs, 
whose "Album" is "Kind of Blue". (3 MARKS)
*/
-- ANSWER 10 --
db.songs.updateMany({"Album": "Kind of Blue"}, {$unset: {"Title": ""}});


/* QUESTION 11
Write the MongoDB command to replace the Title Key Value from 
the 3rd document from above with "Advanced Database Systems". (2 MARKS)
*/
-- ANSWER 11 --
db.songs.update({"_id": "171690217"}, {$set: {"Title": "Advanced Database Systems"}});


/* QUESTION 12
Write the MongoDB command to remove all documents from the "songs" collection
(2 MARKS)
*/
-- ANSWER 12 --
db.songs.deleteMany({});


/* QUESTION 13
For each of th1e following scenarios, state whether a relational or No-SQL database
is more appropriate AND the reason for your choice.  
1 Mark for the choice, 2 Marks for the reason. (6 MARKS)
    

    /* Scenario 1 
    You are building a web-based inventory management system for a medium size 
    warehouse who stores products for multiple clients and provides shipping 
    services internationally.
    */
    /* 
    ANSWER:
    - Choice: Relational Database
    - Reason: 
    A relational database would be more appropriate for an inventory management system for a medium-sized warehouse with multiple clients because 
    the relational databases are good in handling structured data, relationships, and transactions and the data in this scenario, such as product 
    information, client details, and shipping records, can be well-organized into tables with defined relationship. Moreover, this can ensure about
    the data integrity and consistency.
     */
    
    /*
    Scenario 2
    You are developing a search engine to compete with Google and Bing for online retailers so their
    customers can easily find their products.
    */
    /* 
    ANSWER: 
    - Choice: NoSQL Database
    - Reason: 
    A NoSQL database would be more appropriate for developing a search engine for online retailers. This is because the NoSQL databases, 
    provide flexibility in handling unstructured or semi-structured data, which is common in search engine applications. Moreover, the NoSQL 
    databases can scale horizontally to handle large number of volumes of data and traffic, making them more suitable for the dynamic and 
    rapidly changing nature of search engine queries and results.
    */
