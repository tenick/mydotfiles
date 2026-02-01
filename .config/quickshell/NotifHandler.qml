import QtQuick
import Quickshell
import Quickshell.Services.Notifications

pragma Singleton

Singleton {
    id: notifHandlerRoot
    property ListModel notifs: ListModel {}

    function add(notif) {
        const id = Date.now() + Math.random();

        const timer = Qt.createQmlObject(`
            import QtQuick
            Timer {
                interval: 8000
                repeat: false
                running: true
                onTriggered: remove(${id})
            }
        `, notifHandlerRoot);

        notifs.append({
            id: id,
            notif: notif,
            timer: timer
        });
        // console.log("yea we added: ", notifs.count);
        // console.log("sample: ", notifs.get(notifs.count-1).notif.body);
    }

    function remove(id) {
        for (let i = 0; i < notifs.count; i++) {
            if (notifs.get(i).id === id) {
                notifs.get(i).timer.destroy();
                notifs.get(i).notif.dismiss();
                notifs.remove(i);
                return
            }
        }
    }

    function pause(id) {
        for (let i = 0; i < notifs.count; i++) {
            if (notifs.get(i).id === id) {
                notifs.get(i).timer.running = false;
                notifs.get(i).timer.interval = 4000;
                return
            }
        }
    }

    function resume(id) {
        for (let i = 0; i < notifs.count; i++) {
            if (notifs.get(i).id === id) {
                notifs.get(i).timer.restart();
                return
            }
        }
    }

    NotificationServer {
        id: notifServer

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true
            // notifModel.append({ notif: notif })
            add(notif);
            // console.log("bro", 
            // notif.body, 
            // notif.summary, 
            // "app icon:", notif.appIcon, 
            // "image:", notif.image, 
            // typeof(notifServer.notifs));
        }
    }
}
