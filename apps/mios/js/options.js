/*
 * options.js
 *
 * Updated 2015.11.17
 * Code and documentation licensed under the MIT license
 *
 */

jQuery(document).ready(function () {
  'use strict';

  /* Toggle Animation */
  $.fn.slideFadeToggle = function (speed, easing, callback) {
    return this.animate({
      opacity: 'toggle',
      height: 'toggle'
    }, speed, easing, callback);
  };

  /* Accordion Content */
  $('.tab-content .tab-collapsed').hide();
  $('.tab-accordion .tab').on('click', function () {
    $(this).find('.tab-content > .tab-collapsed').slideToggle();
  });

  /* Sticky Header */
  $('header').sticky({
    topSpacing: 0
  });

  /* Progress Settings */
  $('.progress').asPieProgress({
    namespace:  'progress',
    min:        0,
    max:        100,
    goal:       100, // 100%
    size:       80,  // in px
    speed:      40,  // speed of 1/100
    barcolor:   '#fa5349',
    barsize:    '2',
    trackcolor: '#f2f0f2',
    fillcolor:  'none',
    easing:     'ease'
  });

  $('.progress-item').hover(function () { // initiate progress item
    $(this).children('.progress').asPieProgress('start');
  });

  /* Flexslider Settings */
  /*$('.flexslider').flexslider({ // initiate responsive slideshow
    animation: 'slide'
  });*/

  /* Blockquote Settings */
  $('.blockquote-wrapper').flexslider({
    selector:       '.blockquote-flexslider > .blockquote-slide',
    animation:      'slide',
    controlNav:     false,
    directionNav:   true,
    animationLoop:  true,
    slideshow:      false,
    direction:      'horizontal',
    move:           1,
    maxItems:       1
  });

  /* Site Loading */
  jQuery(window).load(function () { // makes sure the whole site is loaded
    jQuery('.site-loading').fadeOut(); // will first fade out the loading animation
    jQuery('.site').delay(250).fadeOut('slow'); // fades out the DIV that covers the website
  });

  /* Navigation Controls */
  jQuery('.nav-btn').on('click', function () {
    jQuery('.nav-menu').slideFadeToggle();
    return false;
  });

  $('.nav-menu a[href^="#"], .hero-arrow-down').on('click', function () {
    jQuery('.nav-menu').hide();
    var the_id = $(this).attr('href');
    $('html, body').animate({
      scrollTop: $(the_id).offset().top - 68
    }, 'slow');
    return false;
  });

  $('.nav-top').on('click', function () {
    jQuery('.nav-menu').hide();
    var the_id = $(this).attr('href');
    $('html, body').animate({
      scrollTop: $(the_id).offset().top
    }, 'slow');
    return false;
  });

  $('.nav-menu').onePageNav({
    currentClass:     'active',
    changeHash:       false,
    scrollSpeed:      750,
    scrollThreshold:  0.5,
    filter:           ':not(.contact)',
    easing:           'swing',
    begin:            function () {},
    end:              function () {},
    scrollChange:     function () {}
  });
});