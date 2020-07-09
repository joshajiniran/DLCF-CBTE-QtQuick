function dbInit() {
    var db = LocalStorage.openDatabaseSync("cbteDB", "", "A CBTE app", 1000000)
    
    try {
        db.transaction(function (tx) {
            // Create database with tables Subjects and Users if it doesn't already exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS Users(\
user_id INTEGER PRIMARY KEY AUTOINCREMENT,
firstname TEXT NOT NULL, 
lastname TEXT NOT NULL,   
gender CHARACTER(1) NOT NULL,
passcode TEXT NOT NULL UNIQUE, 
isAdmin BOOLEAN DEFAULT 0,
timestamp text not null default current_timestamp)')
            
            tx.executeSql('CREATE TABLE IF NOT EXISTS Subjects(\
subject_id INTEGER PRIMARY KEY AUTOINCREMENT, 
name TEXT NOT NULL UNIQUE, 
no_of_questions INTEGER NOT NULL, 
time_alloted TEXT NOT NULL, 
time_created text not null default current_timestamp)')
            
            tx.executeSql('create table if not exists Questions(\
question_id integer primary key autoincrement,
question_text text not null,
subject_id integer not null references Subjects(subject_id) on delete cascade 
deferrable initially deferred)')
            
            tx.executeSql('create table if not exists Options(\
option_id integer primary key autoincrement,
option_text text not null,
question_id integer not null references Questions(question_id) on delete cascade 
deferrable initially deferred)')
            
            tx.executeSql('create table if not exists Answers (\
answer_id integer primary key autoincrement,
question_id integer not null references Questions(question_id) on delete cascade
deferrable initially deferred,
option_id integer not null references Options(option_id) on delete cascade
deferrable initially deferred)')
            
            tx.executeSql('create table if not exists User_Choices (\
id integer primary key autoincrement,
user_id integer not null references Users(user_id) on delete cascade
deferrable initially deferred,
question_id integer not null references Questions(question_id) on delete cascade
deferrable initially deferred,
option_id integer not null references Options(option_id) on delete cascade
deferrable initially deferred,
is_correct boolean)')
            
            tx.executeSql('create table if not exists Results (\
id integer primary key autoincrement,
user_id integer not null references Users(user_id) on delete cascade 
deferrable initially deferred,
subject_id integer not null references Subject(subject_id) on delete cascade 
deferrable initially deferred,
score integer,
remark text)')
            
            try {
                // Add an administrator automatically
                tx.executeSql("INSERT OR IGNORE INTO Users VALUES (1, 'Super', 'Admin', 'M', 'admin@123', 1, current_timestamp)")
            } catch (err) {
                console.log("Info: A superadmin already exist")
            }
        })
    } catch (err) {
        console.log("Error creating table in database: " + err)
    }
}

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("cbteDB", "", "A CBTE app", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    
    return db
}

function dbGetUsers() {
    var db = dbGetHandle()
    var res
    
    db.transaction(function (tx) {
        res = tx.executeSql('select * from Users')
        for (var i = 0; i < res.rows.length; i++) {
            userModel.append({ 
                                 firstname: res.rows.item(i).firstname,
                                 lastname: res.rows.item(i).lastname,
                                 gender: res.rows.item(i).lastname
                             })
        }
    })
}

function dbInsertUser(fn, ln, pc, gd, ad) {
    var db = dbGetHandle()
    var last_row_id = 0
    
    db.transaction(function (tx) {
        try {
            tx.executeSql('INSERT INTO Users (firstname, lastname, passcode, gender, isAdmin) VALUES(?, ?, ?, ?, ?)', [fn, ln, pc, gd, ad])
            console.log("Successfully created user")
            var result = tx.executeSql('select last_insert_rowid()')
            last_row_id = result.insertId
        } catch (err) {
            console.log(err)
        }
    })
    
    return last_row_id
}

function dbDeleteUser(u_id) {
    var db = dbGetHandle()
    
    db.transaction(function (tx) {
        var query = tx.executeSql('delete from Users where id=?', [u_id]) 
    })
}

function dbGetSubjects() {
    var db = dbGetHandle()
    var res
    
    db.transaction(function (tx) {
        res = tx.executeSql('select name, no_of_questions, time_alloted from Subjects')
        for (var i = 0; i < res.rows.length; i++) {
            subjectsModel.append({ 
                                    title: res.rows.item(i).name,
                                    no_questions: res.rows.item(i).no_of_questions,
                                    time_alloted: res.rows.item(i).time_alloted
                                })
        }
    })
}

function dbGetSubjectInfo(subj_text) {
    var db = dbGetHandle()
    var res
    
    db.transaction(function(tx) {
        res = tx.executeSql('select no_of_questions, time_alloted from Subjects where name=?', [subj_text])
        for (var i = 0; i < res.rows.length; i++) {
            timeAllotedField.text = res.rows.item(i).time_alloted
            noQuestionsField.text = res.rows.item(i).no_of_questions
        }
    })
}

function dbCreateSubject(sn, nq, ta) {
    var db = dbGetHandle()
    
    db.transaction(function(tx) {
        try {
            tx.executeSql('insert into Subjects (name, no_of_questions, time_alloted) values(?, ?, ?)', [sn, nq, ta])
            console.log(('Successfully created subject'))
        } catch (err) {
            console.log(err)
        }
    })
}

function dbUpdateSubject(nq, ta, sn) {
    var db = dbGetHandle()
    
    db.transaction(function(tx) {
        try {
            tx.executeSql('update Subjects set no_of_questions=?, time_alloted=? where name=?', [nq, ta, sn])
            console.log(('Successfully updated subject'))
        } catch (err) {
            console.log(err)
        }
    })
}

function dbDeleteSubject(sbjt) {
    var db = dbGetHandle()
    
    db.transaction(function(tx) {
        try {
            tx.executeSql("delete from Subjects where name=?", [sbjt])
            console.log('Successfully deleted subject')
        } catch (err) {
            console.log(err)
        }
    })
}

function dbCreateResult(u_id, s_id) {
    var db = dbGetHandle()
    
    db.transaction(function(tx) {
        var query = tx.executeSql('insert into Results (user_id, subject_id) values(?, ?)', [u_id, s_id])
    })
}
