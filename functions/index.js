const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
  .document('Messages/{chatId1}/{chatId2}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.fromUid
    const idTo = doc.toUid
    const contentMessage = doc.content

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('Users')
      .where('uid', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {

          if (userTo.data().token !== idFrom) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('uid', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().name}`)
                  const payload = {
                    notification: {
                      title: `You have a message from "${userFrom.data().name}"`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().token, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user ')
          }
        })
      })
    return null
  })