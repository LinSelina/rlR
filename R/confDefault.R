# define default hyper-parameters
rlR.conf.default = list(
render = TRUE,
agent.gamma = 0.99,
policy.maxEpsilon = 0.01,
policy.minEpsilon = 0.01,
policy.decay = 1, # exp(-1.0 / 10),
replay.memname = "Uniform",
replay.epochs = 1L,
interact.maxiter = 500L
)


rlR.conf.avail = names(rlR.conf.default)

rlR.conf4log = list(
replay.mem.laplace.smoother = 0.001,
resultTbPath = "Perf.RData",
ROOTFOLDERNAME = "logout",
LOGGERNAMENN = "nn.logger",
LOGGERNAMERL = "rl.logger",
NNSufix = "nn.log",
RLSufix = "rl.log.R"
)