window.ReactOnRails = window.ReactOnRails || require('react-on-rails').default;

// import HelloWorld from '../bundles/HelloWorld/components/HelloWorld';
import Simple from '../bundles/Headers/Simple'
// import ShowCart from '../bundles/Cart/Show'
// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
    Simple
});
