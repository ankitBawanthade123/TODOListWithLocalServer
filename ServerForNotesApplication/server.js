const express = require('express')
const mongoose = require('mongoose')
var  app = express()
var Data = require("./noteSchema")

mongoose.connect('mongodb://localhost/myDB')

mongoose.connection.once("open", () => {
    console.log("Connection established with DB")
}).on("error", (error) => {
    console.log("Failed to connect: " + error)
})


// CREATE a route to create a note
// Post request
app.post("/create", (req, res) => {
    console.log(req)
    var note = new Data ({
        noteId: req.get('noteId'),
        title: req.get('title'),
        isCompleted: req.get('isCompleted')
    })

    note.save().then( () => {
        if (note.isNew == false) {
            console.log("Data Saved")
            res.send("Saved Data !!")
        } else {
            console.log("Failed to save Data")
            res.send("Faile to save Data !!")
        }
    })
})


// http:192.168.1.142:8081/create
var server = app.listen(8081, "192.168.1.142", () => {
    console.log("Sever is running")
})

// CREATE a route to update a note

app.post('/update', (req, res) => {
    Data.findByIdAndUpdate(
        req.get("id"), // Query filter
        {
            noteId: req.get("noteId"),
            title: req.get("title"),
            isCompleted: req.get("isCompleted")
        },
        { new: true } // Options to return the updated document
    )
    .then(updatedDoc => {
        if (updatedDoc) {
            console.log("Document updated:", updatedDoc);
            res.send("Updated successfully!");
        } else {
            res.status(404).send("Document not found.");
        }
    })
    .catch(error => {
        console.error("Error updating document:", error);
        res.status(500).send("Error updating document.");
    });
});


app.post('/delete', (req, res) => {
    const noteId = req.get("id");

    Data.findOneAndDelete({ _id: noteId })
        .then((deletedNote) => {
            if (!deletedNote) {
                return res.status(404).json({ error: "Note not found" });
            }
            res.json({ message: "Note deleted successfully", deletedNote });
        })
        .catch((err) => {
            console.error(err);
            res.status(500).json({ error: "An error occurred while deleting the note" });
        });
});


// CREATE a route to fetch all notes
app.get('/fetch', (req, res) => {
    Data.find({}).then((DBitems) => {
        res.send(DBitems)
    })
})
