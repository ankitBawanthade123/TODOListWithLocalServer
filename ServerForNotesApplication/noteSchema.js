var mongoose = require('mongoose')
var Schema = mongoose.Schema

var note = new Schema( {
    noteId: String,
    title: String,
    isCompleted: String,
})

const Data = mongoose.model("data", note)
module.exports = Data