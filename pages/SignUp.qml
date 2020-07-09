import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import QtQuick.LocalStorage 2.0
import "../logic/Database.js" as JS

Page {
    title: qsTr("Signup Page")
    
    Notifier { id: notifier }
    
    ButtonGroup { id: genderGroup }
    ButtonGroup { id: subjectsGroup }
    
    GroupBox {
        id: subjectPane
        title: "Register"
        width: parent.width * 0.6
        height: parent.height * 0.45
        anchors.centerIn: parent
        
        GridLayout {
            id: formLayout
            columns: 2
            columnSpacing: 3
            anchors.fill: parent
            Layout.margins: 20
            //        width: parent.width * 0.70
            //        height: parent.height * 0.50
            
            TextField {
                id: firstName
                placeholderText: qsTr("Firstname")
                font { family: "Helvetica"; pixelSize: 18 }
                Layout.fillWidth: true
            }
            
            TextField {
                id: lastName
                placeholderText: qsTr("Lastname")
                font { family: "Helvetica"; pixelSize: 18 }
                Layout.fillWidth: true
            }
            
            TextField {
                id: passcode
                placeholderText: qsTr("Choose password")
                font { family: "Helvetica"; pixelSize: 16 }
                echoMode: TextInput.Password
                Layout.fillWidth: true
                
                onTextChanged: {
                    if (passcode.text !== passcodeagain.text && passcodeagain.text !== "") {
                        status.text = "Passwords do not match"
                        status.color = "red"
                    } else {
                        status.text = ""
                    }
                }
                
                onFocusChanged: {
                    if (passcode.text !== passcodeagain.text && passcodeagain.text !== "") {
                        status.text = "Passwords do not match"
                        status.color = "red"
                    } else {
                        status.text = ""
                    }
                }
            }
            
            TextField {
                id: passcodeagain
                placeholderText: qsTr("Enter password again")
                font { family: "Helvetica"; pixelSize: 16 }
                echoMode: TextInput.Password
                Layout.fillWidth: true
                
                onTextChanged: {
                    if (passcodeagain.text !== passcode.text && passcode.text !== "") {
                        status.text = "Passwords do not match"
                        status.color = "red"
                    } else {
                        status.text = ""
                    }
                }
                
                onFocusChanged: {
                    if (passcodeagain.text !== passcode.text) {
                        status.text = "Passwords do not match"
                        status.color = "red"
                    } else {
                        status.text = ""
                    }
                }
            }
            
            ComboBox {
                id: position
                model: ["Candidate", "Administrator"]
                currentIndex: -1
                Layout.fillWidth: true
                flat: true
            }
            
            Row {
                Layout.fillWidth: true
                
                RadioButton {
                    text: qsTr("Male")
                    font { family: "Helvetica"; pixelSize: 16 }
                    ButtonGroup.group: genderGroup
                }
                RadioButton {
                    text: qsTr("Female")
                    font { family: "Helvetica"; pixelSize: 16 }     
                    ButtonGroup.group: genderGroup
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                
                ListView {
                    id: subjectsView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    orientation: Qt.Horizontal
                    visible: position.currentIndex == 0 ? true : false
                    model: SubjectModel { }
                    delegate: CheckDelegate {
                        text: title
                        
                        onClicked: {
                            userSubjectsChoice.append({ "name": title })
                        }
                    }
                }
            }
            
            Button {
                id: submitBtn
                text: qsTr("SUBMIT")
                highlighted: true
                Layout.alignment: Qt.AlignRight
                
                onClicked: {
                    register()
                }
            }
            
            Label {
                id: status
                Layout.row: 4
                Layout.fillWidth: true
            }
            
            Text {
                id: gotoLogin
                text: qsTr("< Return to login page")
                font.italic: true
                Layout.topMargin: 10
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                horizontalAlignment: Text.AlignRight
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: stackView.replace("qrc:/pages/Login.qml")
                }
            }
        }
    }
    
    ListModel {
        id: userSubjectsChoice
    }
    
    function register() {
        if (firstName.text == "" || lastName.text == "" || position.displayText == "" || passcode.text == "" || genderGroup.checkState == Qt.Unchecked) {
            notifier.msgTxt = "Some fields are missing. Please fill them correctly"
            notifier.open()
        } else if (position.currentIndex == 1){
            JS.dbInsertUser(firstName.text, lastName.text, passcode.text, genderGroup.checkedButton.text.charAt(0), position.currentIndex)
            stackView.push("qrc:/pages/Login.qml")
        } else {
            // double insert for candidate, profile and subjects offered
            try {
                var rowid = JS.dbInsertUser(firstName.text, lastName.text, passcode.text, genderGroup.checkedButton.text.charAt(0), position.currentIndex)
                
                var db = JS.dbGetHandle()
                db.transaction(function (tx) {
                    try {
                        // get last user insert id and also get the ids of the subjects offered
                        for (var i = 0; i < subjectsView.model.count; i++) {
                            tx.executeSql('insert into Results (user_id, subject_id) values(?, ?)', [rowid, userSubjectsChoice.get(i).name])
                        }
                        
                        // after a successful user & subject creation, navigate to login page
                        stackView.push("qrc:/pages/Login.qml")
                    } catch (er) {
                        console.log(er)
                    }
                })
            } catch (err) {
                console.log(err)
            }
        }
    }
}
