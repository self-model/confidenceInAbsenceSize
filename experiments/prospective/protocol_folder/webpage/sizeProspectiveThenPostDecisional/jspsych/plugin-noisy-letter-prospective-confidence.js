var jsNoisyLetterProspective = (function (jspsych) {
  "use strict";

  const info = {
		name: 'noisyLetter',
		parameters: {
        image: {
                type: jspsych.ParameterType.IMAGE,
                default: '',
            },
        pixel_size_factor: {
            type: jspsych.ParameterType.INT,
            default: 3,
            description: 'the actual width in pixels of every pixel in the image'
                },
        max_p: {
            type: jspsych.ParameterType.FLOAT,
            default: 0.5,
            description: 'the maximum visibility'
        },
        present: {
            type: jspsych.ParameterType.INT,
            default: 1,
            description: 'is the letter present (1) or absent (0)'
        },
        frame_rate: {
            type: jspsych.ParameterType.INT,
            pretty_name: "Frame rate",
            default: 15,
            description: "Frame rate (Hz)"
        },
      choices: {
        type: jspsych.ParameterType.STRING,
        pretty_name: "Choices",
        description: "Choice keys. The first item corresponds to no letter, the second to letter",
        default: ['f','g']
      },
      post_click_delay: {
        type: jspsych.ParameterType.INT,
        pretty_name: "Post click delay",
        default: 200,
        description: "Time to display choice before moving to the feebdack screen (ms)"
      },
      pre_stim_time: {
        type: jspsych.ParameterType.INT,
        pretty_name: "Pre stimulus delay",
        default: 750,
        description: "Time before displaying the stimulus"
      },
      descend: {
        type: jspsych.ParameterType.BOOL,
        description: "should the occluder lines go down?",
        default: false
      },
      min_conf_time: {
        type: jspsych.ParameterType.INT,
        pretty_name: "Minimum confidence time",
        default: 200,
        description: "Minimum time to rate confidence (to avoid hasty responding)"
      }
		}
	}

  /**
   * **PLUGIN-NAME**
   *
   * SHORT PLUGIN DESCRIPTION
   *
   * @author MATAN MAZOR
   * @see {@link https://DOCUMENTATION_URL DOCUMENTATION LINK TEXT}
   */
  class NoisyLetterProspectivePlugin {
    constructor(jsPsych) {
      this.jsPsych = jsPsych;
    }
    trial(display_element, trial) {

      display_element.innerHTML = '<div id="p5_loading" style="font-size:60px">+</div>';

      //open a p5 sketch
      let sketch = (p) => {

        const du = p.min([window.innerWidth, window.innerHeight, 600])*7/10 //drawing unit

        p.preload = () => {
    			this.img = p.loadImage(trial.image);
    		}

        var draw_choices = (response) => {

            p.textFont('Noto Sans Mono');
            if (trial.choices[0]=='f') {
            p.push()
            p.translate(-window.innerWidth/4,0)
            p.textSize(20)
            p.fill(response=='f'? 255 : 200)
            p.text('just noise',0,0)
            p.fill(response=='g'? 255 : 200)
            p.translate(window.innerWidth/2,0)
            p.text('letter in noise',0,0)
            p.pop()
          } else if (trial.choices[0]=='g') {
            p.push()
            p.translate(-window.innerWidth/4,0)
            p.textSize(20)
            p.fill(response=='f'? 255 : 200)
            p.text('letter in noise',0,0)
            p.translate(window.innerWidth/2,0)
            p.fill(response=='g'? 255 : 200)
            p.text('just noise',0,0)
            p.pop()
          }

          p.push()
          p.textSize(15)
          p.fill(200);
          p.translate(-window.innerWidth/4,40)
          p.text('press F',0,0)
          p.translate(window.innerWidth/2,0)
          p.text('press G',0,0)
          p.pop()
          p.pop()

      };

      var rate_confidence = (confidence) => {

        p.background(128); //gray

        // frame
        p.push()
        p.translate(p.width/2,p.height/2)
        p.rectMode(p.CENTER)
        p.noFill()
        p.stroke('black')
        p.strokeWeight(3)
        p.rect(0,0,(this.img.width+1)*trial.pixel_size_factor,(this.img.height+1)*trial.pixel_size_factor)
        p.pop()
                
        window.dial_position = p.max(p.min(p.mouseY,window.innerHeight*3/4),window.innerHeight/4);
        // draw scale
        p.push()
        p.stroke(0);
        p.strokeWeight(4);
        p.line(window.innerWidth/2 + 60, window.innerHeight/4, window.innerWidth/2 + 60, window.innerHeight*3/4)
        p.pop()

        // add labels

        p.push()
        p.textAlign(p.LEFT)
        p.textSize(30)
        p.textFont('Quicksand');
        p.text('Very confident',window.innerWidth/2+100,window.innerHeight/4)
        p.text('Not at all confident',window.innerWidth/2+100,window.innerHeight*3/4)
        p.pop()

        if (window.mouseMoved) {
          // draw dial
          p.push()
          p.stroke(0);
          p.strokeWeight(0.5);
          p.fill(255)
          p.ellipse(window.innerWidth/2+ 60,window.dial_position,20)
          p.pop()
        }

      }

        //sketch setup
        p.setup = () => {
          p.createCanvas(window.innerWidth, window.innerHeight);
          p.fill(255); //white
          p.strokeWeight(0)
          p.background(128); //gray
          p.frameRate(trial.frame_rate);
          p.textFont('Noto Sans Mono');
          p.textAlign(p.CENTER, p.CENTER)
          p.rectMode(p.TOP, p.LEFT);
          p.imageMode(p.CENTER);
          p.noCursor();
          trial.response  = NaN;
          trial.RT = Infinity;
        //   draw_choices(trial.response)
          this.img.loadPixels();

          window.img_pixel_data = [];
          window.presented_pixel_data = [];

        window.confidence=-1;
        window.mouseMoved=false;

          for (let y = 0; y < this.img.height; y++) {
            var row = [];
            for (let x = 0; x < this.img.width; x++) {
              row.push(this.img.get(x,y))
            }
            window.img_pixel_data.push(row);
          }


          p.textSize(this.img.height*trial.pixel_size_factor);

          // determine top left point of image
          window.ref_x = p.innerWidth/2;
          window.ref_y = p.innerHeight/2;

          window.frame_number = 0;

          window.start_time = p.millis()
        }

        p.draw = () => {

            p.background(128); //gray
            if (p.millis()-window.start_time<trial.pre_stim_time) {
                p.push()
                p.translate(p.width/2,p.height/2)
                p.rectMode(p.CENTER)
                p.noFill()
                p.stroke('black')
                p.strokeWeight(3)
                p.rect(0,0,(this.img.width+1)*trial.pixel_size_factor,(this.img.height+1)*trial.pixel_size_factor)
                p.pop()

             } else if (window.confidence==-1) {

                window.trial_part = 'rating confidence';
                rate_confidence(window.confidence)
    
              } else if (p.millis()-window.start_time < trial.RT + trial.post_click_delay) {

            window.trial_part='display stimulus';


            // draw noise 
            var presented_frame = [];
            for (let y = 0; y < this.img.height; y++) {
              var presented_row = [];
              for (let x = 0; x < this.img.width; x++) {
                p.push()
                if (p.millis()-window.start_time<trial.pre_stim_time) {
                  p.fill(128)
                  presented_row.push(128);
                } else {
                  // var color = window.img_pixel_data[y][x]
                  if (Math.random() <= trial.present*trial.max_p) {
                    p.fill(window.img_pixel_data[y][x]);
                    // Saving only the R channel! to save all four channels, delete the [0] from the next line
                    presented_row.push(window.img_pixel_data[y][x][0]);
                  } else {
                    var random_x = Math.floor(Math.random()*this.img.width);
                    var random_y = Math.floor(Math.random()*this.img.height);
                    p.fill(window.img_pixel_data[random_y][random_x]);
                    // Saving only the R channel! to save all four channels, delete the [0] from the next line
                    presented_row.push(window.img_pixel_data[random_y][random_x][0]);
                  }
                }
                p.translate(p.width/2+x*trial.pixel_size_factor - this.img.width/2*trial.pixel_size_factor,
                  p.height/2+y*trial.pixel_size_factor - this.img.height/2*trial.pixel_size_factor)
                p.rect(0,0,trial.pixel_size_factor,trial.pixel_size_factor)
                p.pop()
              }
              presented_frame.push(presented_row);
            }

            // draw frame (before display)
            p.push()
            p.translate(p.width/2,p.height/2)
            p.rectMode(p.CENTER)
            p.noFill()
            p.stroke('black')
            p.strokeWeight(3)
            p.rect(0,0,(this.img.width+1)*trial.pixel_size_factor,(this.img.height+1)*trial.pixel_size_factor)
            p.pop()

            if (window.frame_number < 76) {
              window.presented_pixel_data.push(presented_frame);
            }
            window.frame_number++

            p.push();
            p.translate(window.innerWidth/2,window.innerHeight/2)

            draw_choices(trial.response)
          }  else {
            p.remove()
            // end trial
            this.jsPsych.finishTrial(window.trial_data);
          }
        }

        p.keyReleased = () => {
          // it's only possible to query the key code once for each key press,
          // so saving it as a variable here:
          var key_code = p.keyCode
          var key = String.fromCharCode(key_code).toLowerCase();
          if ((key=='g' | key=='f') & trial.RT==Infinity & window.confidence>-1) {
            // only regard relevant key presses during the response phase
              trial.response = key;
              trial.RT = p.millis()-window.start_time;
              // data saving
              window.trial_data = {
                presented_pixel_data: window.presented_pixel_data,
                RT: trial.RT,
                response: trial.response,
                max_p: trial.max_p,
                confidence: trial.confidence,
                confidence_RT: trial.confidence_RT
              };
            }
          //  save the image
            // if (key === 'q') {
            //   p.save(`saved-image${Date.parse(Date())}.png`);
            // }
        }

        p.mouseClicked = () => {
          if (p.millis()-window.start_time > trial.pre_stim_time + trial.min_conf_time) {
            window.confidence=1-((window.dial_position-window.innerHeight/4)/(window.innerHeight/2));
            trial.confidence=window.confidence;
            trial.confidence_RT = p.millis()-trial.pre_stim_time;
            window.start_time = p.millis();
          }
        }

        p.mouseMoved = () => {
          if (window.trial_part=='rating confidence') {
            window.mouseMoved=true;
          }
        }
    };



      let myp5 = new p5(sketch);
    }
  }
  NoisyLetterProspectivePlugin.info = info;

  return NoisyLetterProspectivePlugin;
})(jsPsychModule);
