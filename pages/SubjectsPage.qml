import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11

Page {
    id: subjectsPage
    ColumnLayout {
        id: parentLayout
        anchors.fill: parent
        anchors.margins: 10
        
        ComboBox {
            id: subjectListCombo
            editable: true
            model: ListModel {
                id: subjectModel
                
            }
            Layout.alignment: Qt.AlignCenter
            
            onAccepted: {
                if (find(editText) === -1)
                    subjectModel.append({text: editText})
            }
        }
        
        TextField {
            id: timeAllotedField
            inputMask: "99:99"
            horizontalAlignment: TextInput.AlignHCenter
            Layout.alignment: Qt.AlignCenter
        }
        
        GridView {
            id: optionsViewer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            Layout.alignment: Qt.AlignCenter
            currentIndex: 0
            cellHeight: 40
            cellWidth: 40
            model: 25
            delegate: ItemDelegate {
                text: index + 1
                highlighted: GridView.isCurrentItem ? true : false
                
                onClicked: {
                    GridView.view.currentIndex = index
                }
            }
        }
        
        GroupBox {
            title: qsTr("Question, Options & Answer")
            Layout.fillHeight: true
            Layout.fillWidth: true
            
            ColumnLayout {
                anchors.fill: parent
                
                TextEdit {
                    Layout.fillWidth: true
                    onTextChanged: {
                        questionArea.text = text
                    }
                }
                
                TextArea {
                    id: questionArea
                    placeholderText: qsTr("Type question here")
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    textFormat: TextEdit.RichText
                    color: "red"
                    font.pixelSize: 18
                }
                
                ComboBox {
                    id: optionsCombo
                    Layout.fillWidth: true
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
            }
        }
        
        RowLayout {
            Layout.column: parentLayout.column + 1
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            
            Button {
                id: previousButton
                Layout.alignment: Qt.AlignLeft
                text: qsTr("<")
                font.pixelSize: 16
                enabled: optionsViewer.currentIndex > 1 ? true : false
                
                onClicked: {
                    
                }
            }
            Button {
                id: nextButton
                Layout.alignment: Qt.AlignRight
                text: qsTr(">")
                font.pixelSize: 16
                
                onClicked: {
                    // no field empty before attempting to save
                    // function to save to database in form of JSON
                    questionModel.append(
                                { 
                                    "number": optionsViewer.currentIndex + 1,
                                    "question": questionArea.text,
                                    "options": optionsModel,
                                    "answer": buttonGroup.checkedButton.text
                                }
                                )
                    
                    optionsViewer.currentIndex += 1
                }
            }
        }
        
    }
    
    Page {
        id: usersPage
        title: "Manage Users"
        
        
    }
    
    Page {
        id: profilePage
        title: "Admin Profile"
    }
}
