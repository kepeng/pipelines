FROM golang

WORKDIR /go/src/github.com/kubeflow/pipelines

COPY . .

RUN go get ./resources/scheduledworkflow/...

# We need to remove this glog package as it conflicts with the glog package in
# /go/src/github.com/golang/glog.
RUN rm -r /go/src/k8s.io/kubernetes/vendor/github.com/golang/glog

RUN go build -o /bin/controller ./resources/scheduledworkflow/*.go

FROM ubuntu

WORKDIR /bin

COPY --from=0 /bin/controller /bin/controller

CMD /bin/controller -alsologtostderr=true