<?php

/**
 * @file
 * Definition of Drupal\rest\Plugin\rest\resource\MenuItemResource.
 */

namespace Drupal\lmsl_course\Plugin\rest\resource;

use Drupal\rest\Plugin\ResourceBase;
use Drupal\rest\ResourceResponse;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Drupal\menu_link_content\Plugin\Menu\MenuLinkContent;

/**
 * Provides a resource for menu links entries in menu.
 *
 * @RestResource(
 *   id = "menu_link_content",
 *   label = @Translation("Menu items"),
 *   serialization_class = "Drupal\menu_link_content\Plugin\Menu\MenuLinkContent",
 *   uri_paths = {
 *     "canonical" = "/menu_links/{menu_name}"
 *   }
 * )
 */
class MenuItemResource extends ResourceBase {

    /**
     * Responds to GET requests.
     *
     * Returns a menu link entries for the specified menu.
     *
     * @return \Drupal\rest\ResourceResponse
     *   The response containing the log entry.
     *
     * @throws \Symfony\Component\HttpKernel\Exception\HttpException
     */
    public function get($menu_name = NULL) {
        if (strlen($menu_name)) {
            $record = db_query("SELECT * FROM {menu_link_content_data} WHERE menu_name = :menu_name", array(':menu_name' => $menu_name))
                ->fetchAllAssoc('link__uri', \PDO::FETCH_ASSOC);
            if (!empty($record)) {
                return new ResourceResponse($record);
            }

            throw new NotFoundHttpException(t('Menu with NAME @id was not found', array('@id' => $menu_name)));
        }

        throw new HttpException(t('No menu NAME was provided'));
    }
}
