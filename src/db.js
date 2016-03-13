import Store from 'indexeddb.io';

export default store = new Store({
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
