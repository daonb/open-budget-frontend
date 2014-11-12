class TrainingStep extends Backbone.Model
    defaults:
        title: null
        content: null
        path: null
        element: null
        orphan: null
        placement: null
        duration: null
        backdrop: null

class TrainingSteps extends Backbone.Collection
    model: TrainingStep

    initialize: (models) ->
        @fetch(dataType: window.pageModel.get('dataType'), reset: true)

    url: ->
        "#{window.pageModel.get('baseURL')}/api/training/#{window.pageModel.get('flow')}"


class TrainingView extends Backbone.View

    initialize: ->
        #window.pageModel.on 'change:mainPage', =>
        @loadTour()

    events:
        "click": "onTrainingButtonClick"

    loadTour: ->
        @steps = new TrainingSteps([])
        @steps.on 'reset', => @initTour(_.map(@steps.models, (i)->i.toJSON()))

    initTour: (steps) ->
        tour = new Tour(
            name: "tour-#{window.pageModel.get('flow')}"
            steps: steps
            basePath: document.location.pathname
            backdrop: true
            backdropPadding: 5
            template: JST.tour_dialog()
        )
        tour.init()
        @tour = tour

    onTrainingButtonClick: (event) ->
        event.preventDefault()
        if not @tour?
            # The tour wasn't initialized (due to loading failure).
            return
        @tour.restart()

$( ->
        console.log "initializing the training view"
        window.trainingView = new TrainingView({el: $("#intro-link"), model: window.pageModel})
)
