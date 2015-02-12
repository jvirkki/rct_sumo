#
#  Copyright 2015 Jyri J. Virkki <jyri@virkki.com>
#
#  This file is part of rct_sumo.
#
#  rct_sumo is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  rct_sumo is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with rct_sumo.  If not, see <http://www.gnu.org/licenses/>.
#


# Implements an rct client for Sumo APIs.
#
# Only a tiny subset supported. Expand as needed.
#
# https://github.com/SumoLogic/sumo-api-doc/wiki/search-api
#


require 'rct_client'

class Sumo < RCTClient

  API_HOST = 'api.sumologic.com'
  BASE_PATH = '/api/v1/logs'


  #----------------------------------------------------------------------------
  # Class description, for automated help.
  #
  def description
    "The RCT Sumo class implements access to some of the common sumologic\n" +
    "search APIs."
  end


  #----------------------------------------------------------------------------
  # CLI definition. Used by the rct framework to determine what CLI commands
  # are available here.
  #
  def cli
    return {
      'search' => Search
    }
  end


  #----------------------------------------------------------------------------
  # General search.
  #
  # Required:
  #     username : Authenticate as this user.
  #     password : Password of username.
  #     query    : The search query
  #
  # Optional:
  #     from     : From time (epoch milliseconds) (default: now-15min)
  #     to       : End time (epoch milliseconds) (default: now)
  #
  # Saves to state:
  #     query_result_json : Full JSON response from sumo
  #
  Search = {
    'description' => "General synchronous search",
    'required' => {
      'username' => [ '-u', '--user', 'User name' ],
      'password' => [ '-P', '--password', 'Password' ],
      'query' => [ '-s', '--search', 'Search query' ],
    },
    'optional' => {
      'from' => [ '-b', '--begin', 'Start time' ],
      'to' => [ '-e', '--end', 'End time' ],
    }
  }

  def search
    user = sget('username')
    password = sget('password')
    query = sget('query')
    start_time = sget('from')
    end_time = sget('to')

    ssettmp(SERVER_PROTOCOL, 'https')
    ssettmp(SERVER_HOSTNAME, API_HOST)
    ssettmp(SERVER_PORT, 443)

    ssettmp(REQ_METHOD, 'GET')
    ssettmp(REQ_AUTH_TYPE, REQ_AUTH_TYPE_BASIC)
    ssettmp(REQ_AUTH_NAME, user)
    ssettmp(REQ_AUTH_PWD, password)
    ssettmp(REQ_PATH, "#{BASE_PATH}/search")

    params = add_param(nil, 'from', start_time)
    params = add_param(params, 'to', end_time)
    params = add_param(params, 'format', 'json')
    params = add_param(params, 'q', query)
    ssettmp(REQ_PARAMS, params)

    result = yield

    if (result.ok)
      json = JSON.parse(result.body)
      sset('query_result_json', json)

      if (is_cli)
        cli_output = ""
        json.each { |h|
          cli_output = cli_output + h['_raw'] + "\n"
        }
        sset(CLI_OUTPUT, cli_output)
      end
    end
    return result
  end

end
