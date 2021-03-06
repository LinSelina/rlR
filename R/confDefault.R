# define default hyper-parameters
rlR.conf.default = list(
render = FALSE,
log = FALSE,
console = FALSE,
agent.gamma = 0.99,
brain.build_fun = NULL,  # user specific function to create surrogate model
policy.maxEpsilon = 0.01,
policy.minEpsilon = 0.01,
policy.decay = 1, # exp(-1.0 / 10),
replay.memname = "Uniform",
replay.epochs = 1L,
interact.maxiter = 5000L,
policy.epi_wait_ini = 5L,  # initially the performance should increase
policy.epi_wait_middle = 25L,
policy.epi_wait_expl = 40L,
agent.reward2adalr = 150,
agent.lr_decay = 0.1,
store_model = TRUE
)


rlR.conf.avail = names(rlR.conf.default)

rlR.conf4log = list(
replay.mem.laplace.smoother = 0.001,
resultTbPath = "Perf.RData",
LOGGERNAMENN = "nn.logger",
LOGGERNAMERL = "rl.logger",
NNSufix = "nn.log",
RLSufix = "rl.log.R"
)
