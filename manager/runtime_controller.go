package manager

import targetlibapi "github.com/loafman1120/TargetLib/api/TargetLib"

// runtimeController is the lifecycle boundary. The compatibility methods on
// Manager delegate here so gRPC transport code does not own runtime policy.
type runtimeController struct{ manager *Manager }

func newRuntimeController(manager *Manager) *runtimeController {
	return &runtimeController{manager: manager}
}

func (r *runtimeController) Start() (*targetlibapi.OperationResponse, error) {
	if err := r.manager.startRuntime(); err != nil {
		return nil, err
	}
	return r.manager.operationResponse()
}

func (r *runtimeController) Restart() (*targetlibapi.OperationResponse, error) {
	if err := r.manager.restartRuntime(); err != nil {
		return nil, err
	}
	return r.manager.operationResponse()
}

func (r *runtimeController) Stop() (*targetlibapi.OperationResponse, error) {
	if err := r.manager.StopService(); err != nil {
		return nil, err
	}
	return r.manager.operationResponse()
}

func (r *runtimeController) State() (*targetlibapi.ServiceState, error) { return r.manager.State() }
