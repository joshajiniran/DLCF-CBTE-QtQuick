import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

Page {
    title: qsTr("Summary Page")
    
    property string fullname: ""
    property string abbrname: ""
    
    Rectangle {
        id: userImg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        width: parent.width * 0.2
        height: width
        radius: width * 0.5
        border { width: 0.8; color: "deeppink" }
        
        Image {
            id: userpix
            source: "../img/userspix.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
            width: parent.width * 0.5
        }
    }
    
    Label {
        id: userName
        text: fullname
        color: "deeppink"
        font.pixelSize: 16
        font.bold: true
        anchors.top: userImg.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
    }
    
    Label {
        id: lblSubjects
        text: qsTr("Subject Combination")
        font.pixelSize: 20
        anchors.top: userName.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        color: "deeppink"
    }
    
    Rectangle {
        id: subjectCombinations
        color: "#7383bf"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: lblSubjects.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 60
        
        ListView {
            id: view
            anchors.fill: parent
            anchors.leftMargin: 20
            orientation: Qt.Horizontal
            spacing: 10
            model: ["Physics", "Chemistry", "Mathematics", "English"]
            delegate: Label {
                text: modelData
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }
        }
    }
    
    Rectangle {
        color: "#7383bf"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: subjectCombinations.bottom
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 60
        
        Label {
            id: lblTimeAlloted
            text: qsTr("Time Alloted: 1hr 45mins")
            font.pixelSize: 20
            color: "white"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
        }
    }
    
    Button {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30
        text: qsTr("START EXAM")
        highlighted: true
        
        onClicked: stackView.push("qrc:/pages/ExamPage.qml", {"candidateAbbrName": abbrname})
    }
}
