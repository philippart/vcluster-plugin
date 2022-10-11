package main

import (
	"github.com/philippart/vcluster-plugin/syncers"
	"github.com/loft-sh/vcluster-sdk/plugin"
)

func main() {
	ctx := plugin.MustInit()
	plugin.MustRegister(syncers.NewCarSyncer(ctx))
	plugin.MustStart()
}
