# This file regenerates the CRDs and types for this example
#
# Make sure to install deep copy gen before
# go install k8s.io/code-generator/cmd/deepcopy-gen@latest
cd ..

echo "Generate apis ..."
deepcopy-gen --input-dirs github.com/philippart/vcluster-plugin/apis/... -o ./ --go-header-file ../../hack/boilerplate.txt  -O zz_generated.deepcopy

mv github.com/philippart/vcluster-plugin/apis/v1/zz_generated.deepcopy.go apis/v1/zz_generated.deepcopy.go
rm -R github.com

echo "Generate crd ..."
go run gen/main.go > manifests/crds.yaml

echo "Update vendor"
go mod vendor
