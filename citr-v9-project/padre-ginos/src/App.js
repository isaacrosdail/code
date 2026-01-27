
const Pizza = (props) => {
    return React.createElement("div", {}, [
        React.createElement("h1", {}, props.name),
        React.createElement("p", {}, props.description),
    ]);
};

const App = () => {
    return React.createElement(
        "div",
        {class: "hecker"},
        [
            React.createElement("h1", {}, "Padre Gino's"),
            React.createElement(Pizza, {name: "Heart Clogger v6", description: "some dope pizza yo"}, "Hey"),
            React.createElement(Pizza, {name: "no. 6", description: "fries on it i think, idfk"}),
        ]
    );
};

const container = document.querySelector('#root');
const root = ReactDOM.createRoot(container);
root.render(React.createElement(App));