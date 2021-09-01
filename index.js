const express = require("express");
const app = express();
const path = require("path");
const router = express.Router();
const Sequelize = require('sequelize')

app.use(express.json());
app.use(express.urlencoded());

app.set("view engine", "pug");
app.set("views", path.join(__dirname, "views"));

var sequelize = new Sequelize(
    "database",
    null,
    null,
    {
        host: "0.0.0.0",
        dialect: "sqlite",
        pool: {
            max: 5,
            min: 0,
            idle: 10000
        },
        storage: "./data/employeeDb.sqlite"
    }
);

const Employee = sequelize.define('employee', 
    {
        empNo: {
            type: Sequelize.INTEGER,
            unique: true
        },
        firstName: {
            type: Sequelize.STRING,
            allowNull: false
        },
        lastName: {
            type: Sequelize.STRING
        },
        salary: {
            type: Sequelize.INTEGER
        }
    }, 
);

Employee.sync().then(() => {
    console.log("Created/fetched employees table");
});

router.get("/", (req, res) => {
    res.redirect('/list');
});

router.get("/list", (req, res) => {
    Employee.findAll().then(employees => {
        // console.log(employees);
        res.render("list", {title: "Employee List", nav: "list", employees: employees});
    }).catch(err => {
        console.log('Unable to fetch records: ', err);
    });
});

router.get("/create", (req, res) => {
    res.render("create", {title: "Create Employee", nav: "create"});
});

router.post("/create", (req, res) => {
    console.log(req.body);
    let message = "";
    Employee.findOne({ where: { empNo: req.body.empNo } }).then(emp => {
        if (emp) {
            emp.update(req.body);
            message = "Employee updated successfully";
        } else {
            Employee.create(req.body);
            message = "Employee added successfully";
        }
        res.render("create", {title: "Create Employee", nav: "create", message: message});
    }).catch(err => {
        console.log("Unable to add/update employee: " + err);
        message = "Could not add/update employee";
        res.render("create", {title: "Create Employee", nav: "create", message: message});
    })
});

router.get("/delete/:id", (req, res) => {
    console.log("Delete: " + req.params.id);
    let message = "";
    Employee.findByPk(req.params.id).then(emp => {
        if (emp) {
            emp.destroy().then(() => {
                message = "Employee successfully deleted";
            }).catch(err => {
                console.log("Unable to delete employee: " + err);
                message = "Employee couldn't be deleted";
            });
        } else {
            console.log("Unable to delete employee: " + err);
            message = "Employee couldn't be deleted";
        }
        res.redirect("/list");
    }).catch(err => {
        console.log("Unable to delete employee: " + err);
        message = "Employee couldn't be deleted";
        res.redirect("/list");
    });
});

app.use("/", router);
app.listen(process.env.port || 3000, () => console.log("Running at Port 3000"));
