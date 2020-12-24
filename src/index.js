import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

console.log(process.env.ELM_APP_API_HOST);
const app = Elm.Main.init({ flags: { host: process.env.ELM_APP_API_HOST } });
app.ports.storeProducts.subscribe(function (products) {
    if (products.length > 0) {
        const json = JSON.stringify(products);
        localStorage.setItem("products", json);
        console.log("Saved state: ", json)
    }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
