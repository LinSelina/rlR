# The reason that there exist a Configuration object which is throughout the experiment is that we want to look at the effect of those configuration parameters.
RLConf = R6::R6Class("Conf",
  public = list(
    static = NULL,
    conf.log.perf = NULL,   # seperate configuration for output like logging, RData, etc
    # get persistence file prefix
    getPersist = function(foldername) {
      list.str = lapply(names(self$static), function(x) sprintf("-%s: %s-\n", x, self$static[[x]]))
      self$conf.log.perf$str.conf = paste0("\n", toString(list.str))
      hash.conf = openssl::md5(self$conf.log.perf$str.conf)
      str.time = toString(Sys.time())
      str.time = gsub(" ", "_", str.time)
      str.date = toString(Sys.Date())
      filePrefix = file.path(getwd(), foldername, str.date, str.time, hash.conf)
      cat(sprintf("Creating the following output folder %s:\n", filePrefix))
      dir.create(filePrefix, recursive = TRUE)
      self$conf.log.perf$filePrefix = filePrefix
      self$conf.log.perf$resultTbPath =  file.path(filePrefix, rlR.conf4log$resultTbPath)  # RData file persistence place
    },

    initialize = function(...) {
      self$conf.log.perf = data.table::copy(rlR.conf4log)
      self$static = data.table::copy(rlR.conf.default)  # deep copy
      #par.list = list(...)
      #dns = setdiff(names(par.list), rlR.conf.default)
      #list.default = setNames(lapply(dns, function(x) self$static[[x]]), dns)
      self$set(...)
      self$ps()
    },

    get = function(name) {
      self$static[[name]]
    },

    set = function(...) {
      par.list = list(...)
      lapply(names(par.list), function(x) self$updatePara(x, par.list[[x]]))
      flag = self$get("log")
      if (is.null(flag)) flag = FALSE
      if (flag) {
        folder_name = readline(prompt = "Please enter folder name relative to current working directory to store output files\n")
        self$getPersist(folder_name)
      }
    },

    updatePara = function(str.para, val.value) {
      self$static[[str.para]] = val.value
    },

    ps = function() {
      cat("parameters: \n")
      dns = names(self$static)
      lapply(dns, function(x) cat(sprintf("-%s: %s- %s-\n", x, {
            ns = names(self$static[[x]])
            if (is.null(ns)) ns = ""
            ns
        }, self$static[[x]])))
    },

    register = function(namespace) {
      # register namespace
      if (namespace %in% names(self$static)) return(FALSE)
      self$static[[namespace]] = list()
      return(TRUE)
    },

    attachname = function(namespace, list.input) {
      # attach a new subspace of parameters
      if (namespace %in% names(self$static)) return(FALSE)
      self$static[[namespace]] = list.input
      return(TRUE)
    },

    fetchConf = function(namespace) {
      if (namespace %nin% names(self$static))  stop("configuration namespace does not exist")
      if (is.null(self$static[[namespace]])) stop("configuration namespace empty!")
      return(self$static[[namespace]])
    }
  ),
  private = list(),
  active = list()
  )
