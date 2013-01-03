module ApplicationHelper

    def field_us(text,form,field,html_options={})

        options = { :size  => 15,
                    :class => "money_us",                
                    :dir   => "rtl" }.merge(html_options)

        %Q{ <td class="label">#{text}</td>
            <td>#{form.text_field field,options}</td> }.html_safe


    end

    def field_gs(text,form,field,html_options={})
        options = { :size  => 15,                    
                    :class => "money_gs",
                    :precision => 0,
                    :dir   => "rtl" }.merge(html_options)

        %Q{ <td class="label">#{text}</td>
            <td>#{form.text_field field,options}</td> }.html_safe


    end
    

    def field_text(text,colsp,form,field,size,prox_field,html_options={})

        options = {:size       => size,
                   :onkeyup    => "f(this),EnterTab(event,'#{prox_field}')",
                   :onkeydown  => "f(this)",
                   :onkeypress => "return bloqEnter(event)" }.merge(html_options)

        %Q{ <td class="label">#{text}</td>
            <td colspan="#{colsp}">#{form.text_field field, options}</td> }.html_safe
            

    end

    def field_data(form,field,size,prox_field,html_options={})

        options = {:size       => size,
                   :onkeyup    => "Formatadata(this,event),EnterTab(event,'#{prox_field}')",
                   :onkeypress => "return bloqEnter(event)" }.merge(html_options)

        %Q{ #{form.text_field field,options} }.html_safe


    end

    
    def pdf_image_tag(image, options = {})
        options[:src] = File.expand_path(RAILS_ROOT) + '/public/images/' + image
        tag(:img, options)
end

    
end
