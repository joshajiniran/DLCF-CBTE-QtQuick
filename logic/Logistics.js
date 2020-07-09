function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("cbteDB", "", "A CBTE app", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    
    return db
}


function dbValidateUser(un, pc) {
    var res
    var who
    var abbr
    var db = dbGetHandle()
    
    try {
        db.transaction(function(tx) {
            var results = tx.executeSql('SELECT * FROM Users WHERE lastname=? AND passcode=?', [un, pc])
            if (results.rows.length === 1) {
                if (results.rows.item(0).isAdmin) {
                    res = 0
                    who = results.rows.item(0).firstname + " " + results.rows.item(0).lastname
                    stackView.push("qrc:/pages/AdminPage.qml", {"adminName": who})
                } else {
                    res = 1
                    who = results.rows.item(0).firstname + " " + results.rows.item(0).lastname
                    abbr = results.rows.item(0).lastname[0] + ". " + results.rows.item(0).firstname
                    stackView.push("qrc:/pages/SummaryPage.qml", {"fullname": who, "abbrname": abbr})
                }
            } else {
                stackView.push("qrc:/pages/SignUp.qml")
                notifier.msgTxt = "Invalid username or password. Try again or register if you have not registered"
                notifier.open()
            }
        })
        
        return res
    } catch (err) {
        console.log("Error opening database: " + err)
    }
}
