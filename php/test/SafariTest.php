<?php declare(strict_types=1);

namespace Pgsafari\Test;

use Pgsafari\MigrationDirection;
use Pgsafari\Safari;
use Pgsafari\SchemaMeta;
use PHPUnit\Framework\TestCase;
use Yosymfony\Toml\Toml;

final class SafariTest extends TestCase {
  public function testFromJson(): void {
    $projectRoot = self::joinPath(__DIR__, "../..");
    $configPath = self::joinPath($projectRoot, "config.toml");
    $config = Toml::parseFile($configPath);
    $host = $config["host"];
    $port = $config["port"];
    $name = $config["name"];
    $user = $config["user"];
    $password = $config["password"];
    $dsn = "pgsql:"
      . "host=" . $host . ";"
      . "port=" . $port . ";"
      . "dbname=" . $name;
    $pdo = new \PDO($dsn, $user, $password);
    $this->assertNotNull($pdo);

    $safari = Safari::fromDirectory(self::joinPath($projectRoot, "db"));
    $latest = $safari->latestVersion();
    $this->assertSame(1, $latest);
//    $meta = SchemaMeta::read($pdo);
//    $current = $meta === null ? 0 : $meta->version;
//    $migration = $safari->createMigration($current, 1, MigrationDirection::forceUpgrade());
//    var_dump($migration);

//    $out = $safari->empty($pdo);

//    $this->assertEquals("hi", $out);
  }

  private static function joinPath(string $base, string $extra): string {
    $paths = [];
    if ($base !== "") {
      $paths[] = $base;
    }
    if ($extra !== "") {
      $paths[] = $extra;
    }

    return preg_replace("#/+#", "/", join("/", $paths));
  }
}
