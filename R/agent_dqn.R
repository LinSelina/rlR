#' @title  DQN
#'
#' @format \code{\link{R6Class}} object
#' @description Deep Q Network
#'
#' @section Methods:
#' Inherited from \code{AgentArmed}:
#' @inheritSection AgentArmed Methods
#'
#' @return [\code{\link{AgentDQN}}].
#' @export
AgentDQN = R6::R6Class("AgentDQN",
  inherit = AgentArmed,
  public = list(
    initialize = function(env, conf = NULL) {
       if (is.null(conf)) conf = rlR.conf.DQN()
       super$initialize(env, conf)
       self$setBrain()
    },

    setBrain = function() {
       self$brain = SurroNN$new(actCnt = self$actCnt, stateDim = self$stateDim, arch.list = self$conf$get("agent.nn.arch"))
       self$model = self$brain
    },
 
    extractTarget = function(i) {
        ins = self$list.replay[[i]]
        act2update =  ReplayMem$extractAction(ins)
        p.old = self$p.old[i, ]
        self$yhat = p.old  # for calculating the  TD error
        r = ReplayMem$extractReward(ins)
        done = ReplayMem$extractDone(ins)
        if (done) {
          target = r
        } else {
          vec.next.Q = self$p.next[i, ]
          a_1 = which.max(vec.next.Q)  # action index start from 1L
          target = r + self$gamma * max(vec.next.Q)
        }
        mt = p.old
        mt[act2update] = target  # the not active action arm's Q will not be updated
        return(mt)
    },

    afterStep = function() {
          self$replay(self$replay.size)
          self$policy$afterStep()
    },

    afterEpisode = function(interact) {
          self$policy$afterEpisode()
          self$mem$afterEpisode()
    }
    ), # public
  private = list(),
  active = list(
    )
  )

rlR.conf.DQN = function() {
  RLConf$new(
          render = FALSE,
          console = FALSE,
          log = FALSE,
          policy.maxEpsilon = 1,
          policy.minEpsilon = 0.01,
          policy.decay = exp(-0.001),
          policy.name = "ProbEpsilon",
          replay.batchsize = 64L,
          agent.nn.arch = list(nhidden = 64, act1 = "relu", act2 = "linear", loss = "mse", lr = 0.00025, kernel_regularizer = "regularizer_l2(l=0.0)", bias_regularizer = "regularizer_l2(l=0.0)"))
}

AgentDQN$test = function(iter = 1000L, sname = "CartPole-v0", render = FALSE, console = FALSE) {
  conf = rlR.conf.DQN()
  conf$updatePara("console", console)
  interact = makeGymExperiment(sname = sname, aname = "AgentDQN", conf = conf)
  perf = interact$run(iter)
  return(perf)
}

AgentDQN$test2 = function(iter = 1000L, sname = "CartPole-v0", render = FALSE, console = FALSE) {
  env = makeGymEnv("MountainCar-v0", act.cheat = function(a) { if(a ==2) return(3); return(a)}, actcnt = 2)
  agent = makeAgent("AgentDQN", env)
  agent$updatePara(console = TRUE, render = TRUE,  log = TRUE, policy.maxEPsilon = 0.1, policy.minEPsilon = 0.1, policy.decay = 1)
  agent$learn(1000)
}
