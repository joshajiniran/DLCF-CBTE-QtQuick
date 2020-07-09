import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import "../logic/Database.js" as Logic

Page {
    id: root
    title: qsTr("Exam Page")
    
    property int hr: 0
    property int min: 0
    property int secs: 10
    property string candidateAbbrName: ""
    
    Notifier { 
        id: notifier 
        onCloseBtnClicked: stackView.replace("qrc:/pages/Login.qml")
    }
    
    background: Rectangle {
        color: "white"
    }
    
    Timer {
        id: timer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            if (secs > 0)
                secs -= 1
            
            if (secs == 0 && min > 0) {
                min -= 1
                secs = 59
            }
            
            if (secs == 0 && min == 0 && hr > 0) {
                hr -= 1
                min = 59
                secs = 59
            }
            
            if (secs == 0 && min == 0 && hr == 0) {
                timer.stop()
                notifier.msgTxt = "Time Up!'\nThe system has automatically submitted for you.\nThank you!"
                notifier.open()
            }

            timerLbl.text = "TIME LEFT: " + hr + ":" + min + ":" + secs
        }
    }

    ColumnLayout {
        id: examLayout
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        spacing: 0
        
        RowLayout {
            id: infoTopLayout
            Layout.preferredWidth: parent.width
            
            RowLayout {
                Image {
                    id: logo
                    source: "qrc:/img/logo.jpg"
                    sourceSize.height: 96
                    sourceSize.width: 96
                }
                
                Label {
                    id: candidateName
                    text: candidateAbbrName
                    font { family: "Courier MS"; pointSize: 16 }
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }
            }
            
            Label {
                id: timerLbl
                text: qsTr("TIME LEFT: ")
                font { family: "Courier MS"; pointSize: 24 }
                color: "red"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }
        
        TabBar {
            id: subjectBar
            currentIndex: -1
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            
            TabButton {
                text: "Physics"
                font.pixelSize: 14
            }
            TabButton {
                text: "Chemistry"
                font.pixelSize: 14
            }
            TabButton {
                text: "Maths"
                font.pixelSize: 14
            }
            TabButton {
                text: "English"
                font.pixelSize: 14
            }
        }
        
        Frame {
            id: frame
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 150
                    Layout.maximumHeight: 150
                    
                    TextArea {
                        id: questionArea
                        wrapMode: Text.WordWrap
                        readOnly: true
                    }
                }
                
                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
//                    spacing: -10
                    
                    RadioButton {
                        text: qsTr("sfdjljsfl")
                    }
                    RadioButton {
                        text: qsTr("djfldjfs")
                    }
                    RadioButton {
                        text: qsTr("kljfsdlfs")
                    }
                    RadioButton {
                        text: qsTr("lsjdfls")
                    }
                }
            }
        }
        
        RowLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            spacing: 40
            
            Button {
                text: qsTr("Previous")
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignRight
                highlighted: true
            }
            Button {
                text: qsTr("Next")
                Layout.preferredWidth: 100
                Layout.alignment: Qt.AlignLeft
                highlighted: true
            }
        }
        
        GridView {
            id: optionsViewer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            Layout.alignment: Qt.AlignCenter
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
    }
    
    Component.onCompleted: {
        // timer begin
        timer.start()
    }
    
    function updateTimer(h, m) {
        var hr = h;
        var min = m;
        min = min - 1;
        timerLbl.text = "TIME LEFT: " + hr + ":" + min
        
    }
}
