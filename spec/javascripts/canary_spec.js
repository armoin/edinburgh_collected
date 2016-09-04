//= require jquery
//= require chai-jquery

describe('The test suite', function () {
  it('works', function () {
    expect(true).to.be.true
  })

  it('works with jqery', function () {
    $('body').html('<h1 class="header-test">I am a header</h1>')
    expect($('.header-test')).to.have.text('I am a header')
  })
})
