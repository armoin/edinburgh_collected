describe "ImageCalculator", ->
  describe "calculating the dimensions of the scaled image", ->
    describe "it scales the image if at least one of the dimensions is equal the MAX_DIMENSION", ->
      describe "when original has width=400, height=200", ->
        beforeEach ->
          image = {width: 400, height: 200}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 200", ->
          expect(@dimensions.width).toEqual(200)

        it "has a height of 100", ->
          expect(@dimensions.height).toEqual(100)

      describe "when original has width=200, height=400", ->
        beforeEach ->
          image = {width: 200, height: 400}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 100", ->
          expect(@dimensions.width).toEqual(100)

        it "has a height of 200", ->
          expect(@dimensions.height).toEqual(200)

    describe "it scales the image if at least one of the dimensions is greater than the MAX_DIMENSION", ->
      describe "when original has width=640, height=480", ->
        beforeEach ->
          image = {width: 640, height: 480}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 200", ->
          expect(@dimensions.width).toEqual(200)

        it "has a height of 150", ->
          expect(@dimensions.height).toEqual(150)

      describe "when original has width=480, height=640", ->
        beforeEach ->
          image = {width: 480, height: 640}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 150", ->
          expect(@dimensions.width).toEqual(150)

        it "has a height of 200", ->
          expect(@dimensions.height).toEqual(200)

    describe "it doesn't scale the image if the dimensions are both less than the MAX_DIMENSION", ->
      describe "when original has width=4, height=3", ->
        beforeEach ->
          image = {width: 4, height: 3}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 4", ->
          expect(@dimensions.width).toEqual(4)

        it "has a height of 3", ->
          expect(@dimensions.height).toEqual(3)

      describe "when original has width=3, height=4", ->
        beforeEach ->
          image = {width: 3, height: 4}
          @dimensions = ImageCalculator.calculateMeasurements(image).dimensions

        it "has a width of 3", ->
          expect(@dimensions.width).toEqual(3)

        it "has a height of 4", ->
          expect(@dimensions.height).toEqual(4)

  describe "calculating the size of the surrounding canvas", ->
    # the image will rotate within the canvas and so the canvas needs to be a
    # square with sides equal to the diagonal length of the image (i.e. the hypoteneus)
    it "uses the hypoteneus to figure out the required length of the sides of the canvas", ->
      image = {width: 3, height: 4}
      expect(ImageCalculator.calculateMeasurements(image).hypoteneus).toEqual(5)

  describe "calculating the x and y coords of the top left corner", ->
    describe "when width = 200px and height = 150px", ->
      beforeEach ->
        image = {width: 200, height: 150}
        @position = ImageCalculator.calculateMeasurements(image).position

      it "provides an x of 25px", ->
        expect(@position.x).toEqual(25)
      it "provides a y of 50px", ->
        expect(@position.y).toEqual(50)

    describe "when width = 150px and height = 200px", ->
      beforeEach ->
        image = {width: 150, height: 200}
        @position = ImageCalculator.calculateMeasurements(image).position

      it "provides an x of 50px", ->
        expect(@position.x).toEqual(50)
      it "provides a y of 25px", ->
        expect(@position.y).toEqual(25)

