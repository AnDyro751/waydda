window.ReactOnRails = window.ReactOnRails || require('react-on-rails').default;
import SearchScreen from "../bundles/Screens/Search";
import Simple from '../bundles/Headers/Simple'
import Shipment from '../bundles/Headers/Shipment'
import Search from '../bundles/Headers/Search'
// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
    SearchScreen,
    Simple,
    Shipment,
    Search
});
