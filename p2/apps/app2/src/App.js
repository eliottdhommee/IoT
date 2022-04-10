import React from 'react';
import logo from './logo.svg';
import './App.css';
import Home from './Home';

export default () => {
	return (
		<div className="App">
			<header className="App-header">
				<img src={logo} className="App-logo" alt="logo" />
				<a
					className="App-link"
					href="https://reactjs.org"
					target="_blank"
					rel="noopener noreferrer"
				>
					<Home name="App2" />
				</a>
			</header>
		</div>
	);
};
