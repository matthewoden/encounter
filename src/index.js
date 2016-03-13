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
  },
  {
    name: 'dom',
    property: 'dom',
    unique: false
  }
]
});

//initalize store, fetch the first tiem, then start our app.

store
  .init()
  .then(() =>
    store.get(0)
      .then(state => startApp(state, store)
    ));

//start app,
function startApp(startingState, dataStore) {
  const node = document.getElementById('app');
  const { model, dom } = startingState;

  //get last session;
  // if (dom) { node.innerHtml = dom; }

  const app = Encounter.embed( Encounter.Main, node, { getStorage: null })

  //save current state
  app
    .ports
    .setStorage
    .subscribe(function(model) {
      dataStore.put(
        { model: model
        , dom: node.innerHtml
        , id: 0
        }
      )
    });

}
