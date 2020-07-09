import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.12

import "../logic/Database.js" as DB
import ".."

Page {
    id: subjectsPage
    title: qsTr("Manage Subject")
    
    GroupBox {
        id: subjectPane
        title: "Manage subjects"
        width: parent.width * 0.5
        height: parent.height * 0.45
        anchors.centerIn: parent
        
        ColumnLayout {
            id: parentLayout
            anchors.fill: parent
            anchors.margins: 10
            
            ComboBox {
                id: subjectListCombo
                editable: true
                textRole: "title"
                model: SubjectModel { id: subjectsModel }
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                
                onCurrentTextChanged: {
                    DB.dbGetSubjectInfo(currentText)
                }
            }
            
            RowLayout {
                TextField {
                    id: noQuestionsField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Number of questions")
                    onAccepted: optionsViewer.model = Number(text)
                }
                
                TextField {
                    id: timeAllotedField
                    inputMask: "99:99"
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: Layout.width - 30
                }
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Button {
                    id: submitBtn
                    text: qsTr("Submit")
                    Layout.preferredWidth: Layout.width * 0.4
                    highlighted: true
                    
                    onClicked: {
                        var res, query
                        var db = DB.dbGetHandle()
                        db.transaction(function(tx) {
                            query = tx.executeSql('select * from Subjects where name=?', [subjectListCombo.editText])
                            if (query.rows.length > 0) {
                                DB.dbUpdateSubject(noQuestionsField.text, timeAllotedField.text, subjectListCombo.editText)
                                stackView.push("qrc:/pages/QuestionSetupPage.qml", 
                                               {
                                                   "subjectEdited": subjectListCombo.editText,
                                                   "noQuestion": noQuestionsField.text
                                               })
                            } else {
                                DB.dbCreateSubject(subjectListCombo.editText, noQuestionsField.text, timeAllotedField.text)
                                DB.dbGetSubjects()
                                stackView.push("qrc:/pages/QuestionSetupPage.qml", 
                                               {
                                                   "subjectEdited": subjectListCombo.editText,
                                                   "noQuestion": noQuestionsField.text
                                               })
                            }
                        })
                    }
                }
                
                Button {
                    id: deleteBtn
                    text: qsTr("Remove")
                    Layout.preferredWidth: Layout.width * 0.4
                    highlighted: true
                    
                    onClicked: {
                        if (subjectListCombo.displayText !== "" && noQuestionsField.text !== ""
                                && timeAllotedField.text !== "") {
                            DB.dbDeleteSubject(subjectListCombo.displayText)
                            subjectModel.clear()
                            noQuestionsField.clear()
                            timeAllotedField.clear()
                            DB.dbGetSubjects()
                        }
                    }
                }
            }
        }
    }
}
