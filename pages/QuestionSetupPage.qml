import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import QtQuick.LocalStorage 2.12

import "../logic/Database.js" as DB
import "../logic/Logistics.js" as JS

Page {
    title: qsTr("Setup page")
    
    property var noQuestion: null
    property var subjectEdited: null
    
    property bool questionDetailHasChanged
    
    Notifier { id: notifier }
    
    ListModel { id: optionsModel }
    
    GroupBox {
        id: subjectPane
        title: "Manage subject: " + subjectEdited
        width: parent.width * 0.65
        height: parent.height * 0.75
        anchors.centerIn: parent
        
        ColumnLayout {
            id: parentLayout
            anchors.fill: parent
            spacing: 5
            
            GridView {
                id: questionOverview
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 40
                Layout.topMargin: 10
                Layout.alignment: Qt.AlignCenter
                cellHeight: 40
                cellWidth: 40
                highlightFollowsCurrentItem: true
                
                Component.onCompleted: {
                    model = Number(noQuestion)
                    currentIndex = 0
                }
                
                delegate: ItemDelegate {
                    id: gridDelegate
                    text: index + 1
                    highlighted: GridView.isCurrentItem ? true : false
                    
                    onClicked: {
                        GridView.view.currentIndex = index
                        
                        questionArea.clear()
                        optionsModel.clear()
                        
                        var currIndex = GridView.view.currentIndex + 1
                        var db = DB.dbGetHandle()
                        
                        db.transaction(function(tx) {
                            // get question detail from database
                            var curr_subject = tx.executeSql('select subject_id from Subjects where name=?', [subjectEdited])
                            var ques_res = tx.executeSql('select question_text from Questions where question_id=?', [currIndex])
                            
                            if (ques_res.rows.length > 0)
                                questionArea.text = ques_res.rows.item(0).question_text
                            
                            // get options of question from database
                            var opt_res = tx.executeSql('select Options.option_text, Options.question_id from Options inner join Questions on Options.question_id=Questions.question_id where Options.question_id=?', [currIndex])
                            
                            if (opt_res.rows.length > 0) {
                                for (var i = 0; i < opt_res.rows.length; i++)
                                    optionsModel.append({ "optionsText": opt_res.rows.item(i).option_text })
                            }
                            
                            // get answer of options of question from the database
                            var ans_res = tx.executeSql('select Answers.question_id, Answers.option_id from Answers inner join Options on Answers.option_id=Options.option_id where Answers.question_id=?', [currIndex])
                            if (ans_res.rows.length > 0) {
                                // do something
                            }
                        })
                    }
                }
            }
            
            ScrollView {
                id: view
                Layout.fillHeight: true
//                Layout.fillWidth: true
                Layout.preferredWidth: parent.width - 40
                Layout.leftMargin: 20
                Layout.bottomMargin: 10
                Layout.alignment: Qt.AlignTop
                clip: true
                
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                
                TextArea {
                    id: questionArea
                    placeholderText: qsTr("Type question here")
                    textFormat: TextEdit.PlainText
                    color: "steelblue"
                    font.pixelSize: 17
                    topPadding: 10
                    wrapMode: TextEdit.Wrap
                    verticalAlignment: TextEdit.AlignTop
                }
            }
            
            ComboBox {
                id: optionsCombo
                Layout.preferredWidth: parent.width / 2.2
                Layout.leftMargin: 20
                Layout.bottomMargin: 10
                editable: true
                model: optionsModel
                
                onAccepted: {
                    if (find(editText) === -1) {
                        optionsModel.append({optionsText: editText})
                        optionsCombo.currentIndex = -1
                        optionsCombo.editText = ""
                    }
                }
            }
            
            ButtonGroup {
                id: buttonGroup
            }
            
            ListView {
                id: optionsView
                orientation: Qt.Horizontal
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 40
                Layout.leftMargin: 20
                model: optionsModel
                delegate: RadioDelegate {
                    id: control
                    text: modelData
                    ButtonGroup.group: buttonGroup
                    
                    contentItem: Text {
                        rightPadding: control.indicator.width + control.spacing
                        text: control.text
                        font: control.font
                        opacity: enabled ? 1.0 : 0.3
                        color: control.down ? "#17a81a" : "#21be2b"
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        textFormat: TextEdit.RichText
                    }
                    
                    onPressAndHold: {
                        // edit or delete
                        optionsModel.remove(index)
                    }
                }
            }
            
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    id: prevBtn
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr("<")
                    flat: true
                    font.pixelSize: 16
                    enabled: questionOverview.currentIndex > 0 ? true : false
                    
                    onClicked: {
                        questionOverview.currentIndex -= 1
                    }
                }
                Button {
                    id: nxtBtn
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr(">")
                    flat: true
                    font.pixelSize: 16
                    enabled: questionOverview.currentIndex < questionOverview.count - 1 ? true : false
                    
                    onClicked: {
                        questionOverview.currentIndex += 1
                    }
                }
            }
            
            Button {
                id: saveBtn
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 40
                text: qsTr("Save")
                font.pixelSize: 16
                highlighted: true
                
                onClicked: {
                    // no field empty before attempting to save
                    if (questionOverview.currentIndex < 0 || questionArea.text == "" || optionsModel.count <= 0 || buttonGroup.checkState == Qt.Unchecked) {
                        notifier.open()
                        notifier.msgTxt = "Some fields have not been filled/checked"
                    } else {
                        // TODO: database manipulation for question and answers
                        var db = DB.dbGetHandle()
                        db.transaction(function(tx) {
                            var res = tx.executeSql('select subject_id from Subjects where name=?', [subjectEdited])
                            try {
                                tx.executeSql('insert into Questions (question_id, question_text, subject_id) values(?, ?, ?)', [questionOverview.currentIndex + 1, questionArea.text, res.rows.item(0).subject_id])
                            } catch (err) {
                                console.log(err)
                            }
                            
                            try {
                                for (var i = 0; i < optionsModel.count; i++) {
                                    tx.executeSql('insert into Options (option_text, question_id) values(?, ?)', [optionsModel.get(i).optionsText, questionOverview.currentIndex + 1])
                                }
                            } catch (er) {
                                console.log(er)
                            }
                            
                            try {
                                var optionId = tx.executeSql('select option_id from Options where option_text=?', [buttonGroup.checkedButton.text])
                                tx.executeSql('insert into Answers (question_id, option_id) values(?, ?)', [questionOverview.currentIndex + 1, optionId])
                            } catch (e) {
                                console.log(e)
                            }
                        })
                        
                        questionArea.clear()
                        optionsModel.clear()
                        questionOverview.currentIndex += 1
                    }
                }
            }
        }
    } 
}    
