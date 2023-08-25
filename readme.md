# vpnsatoshi
**vpnsatoshi** is a blockchain built using Cosmos SDK and Tendermint and created with [Ignite CLI](https://ignite.com/cli).

## Get started

```
sh start.sh
```

`serve` command installs dependencies, builds, initializes, and starts your blockchain in development.

### Configure

Your blockchain in development can be configured with `config.yml`. To learn more, see the [Ignite CLI docs](https://docs.ignite.com).

### Web Frontend

Ignite CLI has scaffolded a Vue.js-based and React.js-based web app in the `vue` and `react` directories. Run the following commands to install dependencies and start the app:

```
cd vue
npm install
npm run serve
```

```
cd react
npm install
npm run dev
```

The frontend app is built using the `@starport/vue` and `@starport/vuex` packages. For details, see the [monorepo for Ignite front-end development](https://github.com/ignite/web).

To generate react foulder is used:
```
docker run -ti -v $HOME/sdh:/home/tendermint -v $PWD:/apps ignitehq/cli scaffold react
docker run -ti -v $HOME/sdh:/home/tendermint -v $PWD:/apps ignitehq/cli generate hooks
```

## Release
To release a new version of your blockchain, create and push a new tag with `v` prefix. A new draft release with the configured targets will be created.

```
git tag v0.1
git push origin v0.1
```

After a draft release is created, make your final changes from the release page and publish it.

### Install
To install the latest version of your blockchain node's binary, execute the following command on your machine:

```
curl https://get.ignite.com/username/VPNSatoshi@latest! | sudo bash
```
`username/VPNSatoshi` should match the `username` and `repo_name` of the Github repository to which the source code was pushed. Learn more about [the install process](https://github.com/allinbits/starport-installer).

## Learn more

- [Ignite CLI](https://ignite.com/cli)
- [Tutorials](https://docs.ignite.com/guide)
- [Ignite CLI docs](https://docs.ignite.com)
- [Cosmos SDK docs](https://docs.cosmos.network)
- [Developer Chat](https://discord.gg/ignite)
