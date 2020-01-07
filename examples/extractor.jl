# see exmaples.jl first

# Extractor
xml = parsexml("""
<?xml version="1.0" encoding="UTF-8"?>
<university university-name="Julia University">
  <person id="1">
    <age>24</age>
    <study-field>Mechanical Engineering</study-field>
    <GPA>4.5</GPA>
    <taken-courses>Artificial Intelligence</taken-courses>
    <taken-courses>Robotics</taken-courses>
  </person>
  <person id="2">
    <age>18</age>
    <study-field>Computer Engineering</study-field>
    <GPA>4.2</GPA>
    <taken-courses>Julia</taken-courses>
  </person>
</university>
""")

# extract Doc
D = Doc(xml) # StructName(xml) like Doc(xml) extracts the data and stores them in proper format

# Now you can access all of the data by calling the fieldnames

# extract University
U = D.university

U.name # Julia University


# extract Person

P1 = U.people[1]

P1.age # 24
P1.field # Mechanical Engineering
P1.GPA # 4.5
P1.courses # ["Artificial Intelligence", "Robotics"]
P1.id # 1
