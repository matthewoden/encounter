require('./scss/app.scss');

import Encounter from './elm/Main';
import Store from 'indexeddb.io';


//IndexDB store. Holds state and model.
var store = new Store({
  db: 'encounter',
  store: {
    name: 'model',
    keyPath: 'id',
    autoIncrement: false
  },
  indexes: [{
    name: 'model',
    property: 'model',
    unique: false
  }
]
});
const node = document.getElementById('app');


//initalize store, fetch the first tiem, then start our app.

store
  .init()
  .then(() =>
    store.get(0)
      .then(state => startApp(state, store)
    ));

//start app,
function startApp(startingState, dataStore) {
  const { model, dom } = startingState;

  //get last session;
  // if (dom) { node.innerHtml = dom; }

  const app = Encounter.embed( Encounter.Main, node, { getStorage: model })

  //save current state
  app
    .ports
    .setStorage
    .subscribe(function(model) {
      console.log(model)
      dataStore.put(
        { model: model
        , id: 0
        })
    });

  // app.ports.getTextareaHeight.subscribe(function(id){
  //   var textarea = document.getElementById(id);
  //   setTimeout(function(){
  //       textarea.style.cssText = 'height:auto; padding:0';
  //       textarea.style.cssText = 'height:' + el.scrollHeight + 'px';
  //     },0);
  // });


}
