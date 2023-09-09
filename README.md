# Supered @ INBOUND 2023 — Scavenger Hunt

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Run `yarn install` inside of `assets` to setup frontend dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

<img width="250" alt="image" src="https://github.com/getsupered/hunt/assets/1231659/e2d0983d-66cb-4be8-b3e3-4e771d343b10">

## Seeds

A fake leaderboard and completions are included as part of the setup process.

## Login

Locally, you can use "Mock Login" to sign in with a testing account. In production, the auth mechanism
are OAuth and JWT-based flows.

## Code

This app was built in a few days for a conference. So things are a bit hacked together and built with
a "v1 is fine" mentality.

Code organization is somewhat there, although several things were thrown together. The app itself is built
using LiveView, with the main page being a JS carousel (Splide JS).

