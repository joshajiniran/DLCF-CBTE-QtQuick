import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

Page {
    title: qsTr("Admin Page")
    
    property string adminName: ""
    
    // custom admin view
    
    StackLayout {
        id: layout
//        currentIndex: adminBar.currentIndex
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        SubjectsPage {
            id: subjectsPage
            title: "Create a subject exam"
        }
        
        Page {
            id: profilePage
            title: "Manage the application record"
        }
    }
}    
