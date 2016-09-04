describe "FeatureSwitch", ->
  beforeEach ->
    spyOn(window, 'alert')
    loadFixtures 'feature_switch'

  it "alerts if a not-implemented link is clicked", ->
    $('#test-fixture a.not-implemented').trigger('click')
    expect(window.alert).toHaveBeenCalledWith("Sorry, this feature has not been developed yet. We'll let you know when it's ready.")

  it "alerts if a not-implemented button is clicked", ->
    $('#test-fixture button.not-implemented').trigger('click')
    expect(window.alert).toHaveBeenCalledWith("Sorry, this feature has not been developed yet. We'll let you know when it's ready.")

  it "does not alert if an implemented link is clicked", ->
    $('#test-fixture a:not(.not-implemented)').trigger('click')
    expect(window.alert).not.toHaveBeenCalled()

  it "does not alert if an implemented button is clicked", ->
    $('#test-fixture button:not(.not-implemented)').trigger('click')
    expect(window.alert).not.toHaveBeenCalled()

