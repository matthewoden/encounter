import Firebase from 'firebase';


const encounter = new Firebase('https://encounters.firebaseio.com/')

export function login(){
  return new Promise (function(resolve, reject ) {
    encounter.authWithOAuthPopup("facebook", function(error, authData) {
      if (error) {
        reject(error)
      } else {
        resolve(authData);
      }
    });
  });
}

//basic login
login()
  .then(data => console.log(data))
  .catch(err => console.log(err))
