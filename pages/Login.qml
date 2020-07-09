import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Material 2.2
import "../logic/Logistics.js" as JS

Page {
    id: root
    title: qsTr("Login Page")
    
    Component.onCompleted: usernameField.forceActiveFocus()
    
    Notifier { id: notifier; width: parent.width * 0.5; height: parent.height * 0.4 }
    
    Image {
        id: image
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 80
        source: "qrc:/img/exampics"
    }
    
    TextField {
        id: usernameField
        anchors.top: image.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.25
        placeholderText: "Surname..."
        focus: true
        
        onAccepted: {
            if (usernameField.text !== "" && passwordField.text === "")
                passwordField.focus = true
            else if (usernameField.text !== "" && passwordField.text !== "")
                loginBtn.clicked()
        }
    }
    
    TextField {
        id: passwordField
        anchors.top: usernameField.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.25
        placeholderText: "Registration no/Password..."
        echoMode: TextField.Password
        
        onAccepted: {
            if (usernameField.text !== "" && passwordField.text !== "")
                loginBtn.clicked()
            else if (usernameField.text === "" && passwordField.text !== "")
                usernameField.focus = true
        }
    }
    
    Button {
        id: loginBtn
        text: "Login"
        anchors.top: passwordField.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.25
        highlighted: true
        Material.elevation: 5
        
        onClicked: {
            // validate the user against the database
//            stackView.push("qrc:/pages/AdminPage.qml")
            JS.dbValidateUser(usernameField.text, passwordField.text)
        }
    }
}
