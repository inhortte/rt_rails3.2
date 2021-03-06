class ReportsController < ApplicationController
  skip_before_filter :authorize

  def animals
    csv = animal_header +
      ReleasedAnimal.all(:order => [:nickname]).map { |a| anim(a) }.join("\n")
    filename = create_filename
    File.open("/tmp/#{filename}", "w") { |f| f << csv }
    send_file "/tmp/#{filename}", :filename => "animals.csv"
  end

  def animal
    ra = ReleasedAnimal.find(params[:id])
    csv = animal_header + anim(ra)
    render :text => csv
  end

  # per animal report of radiotracking with complete animal data
  def general_report
    ra = ReleasedAnimal.find(params[:id])
    csv = radiotracking_header(true) +
      Radiotracking.find_all_by_released_animal_id(params[:id],
                                                   :order => [:date]).map { |r| rt(r, ra) }.join("\n")
    csv.gsub!(/\xC3\xB5/,'')
    filename = create_filename
    File.open("/tmp/#{filename}", "w") { |f| f << csv.force_encoding("UTF-8") }
    send_file "/tmp/#{filename}", :filename => "report_#{ra.nickname}.csv"
  end

  # per animal report of radiotracking with only animal data within 
  # the radiotrackings table
  def radiotracking
    ra = ReleasedAnimal.find(params[:id])
    csv = radiotracking_header +
      Radiotracking.find_all_by_released_animal_id(params[:id],
                                                   :order => [:date]).map { |r| rt(r) }.join("\n")
    render :text => csv
  end

  private
  def animal_header
    "Nickname,Id,Frequency,Microchip Number,Sex,Birthdate,Release Date,Death Date,Release Site,Release Lat,Release Lng,Cause of Death,Released Animal Remarks\n"
  end

  def radiotracking_header(with_animal = false)
    (with_animal ? animal_header().chop + "," : "") +
      "Date," +
      (with_animal ? "" : "Nickname,Id,Frequency,") +
      "Lat,Lng,Observer,Biotope,Distance from Water,Waterbody Type,Water Level,Precipitation,Temperature,Activity,Radiotracking Remarks\n"
  end

  def rt(rt, ra = nil)
    (ra ? anim(ra) + "," : "") +
      "\"#{rt.date.strftime(STRFTIME)}\"," +
      (ra ? "" : "\"#{rt.nickname.capitalize}\"," +
       "\"#{rt.released_animal.animal_id}\"," +
       "\"#{rt.frequency}\",") +
      "\"#{rt.location_of_animal_N}\"," +
      "\"#{rt.location_of_animal_E}\"," +
      "\"#{rt.obser.observer}\"," +
      "\"#{rt.biotope.biotope}\"," +
      "\"#{rt.distance_from_water.distance_from_water}\"," +
      "\"#{rt.waterbody_type.waterbody_type}\"," +
      "\"#{rt.water_level.water_level}\"," +
      "\"#{rt.precipitation.precipitation}\"," +
      "\"#{rt.temperature.temperature}\"," +
      "\"#{(rt.activity ? "Active" : "Inactive")}\"," +
      "\"#{rt.remarks.gsub(/(\r\n|\n)/," ")}\""
  end

  def anim(ra)
    "\"#{ra.nickname.capitalize}\"," +
      "\"#{ra.animal_id}\"," +
      "\"#{ra.frequency}\"," +
      "\"#{ra.microchip}\"," +
      "\"#{ra.sex}\"," +
      "\"#{ra.birthdate.strftime(STRFDATE)}\"," +
      "\"#{ra.release_date.strftime(STRFDATE)}\"," +
      "\"#{ra.deathdate.strftime(STRFDATE)}\"," +
      "\"#{ra.release_site}\"," +
      "\"#{ra.release_location_N}\"," +
      "\"#{ra.release_location_E}\"," +
      "\"#{ra.cause_of_death.gsub(/(\r\n|\n)/," ")}\"," +
      "\"#{ra.remarks.gsub(/(\r\n|\n)/," ")}\""
  end

  def create_filename
    chars = ('a'..'z').to_a
    1.upto(9).inject("") { |m, _| m += chars[rand(chars.size)] }
  end
end
