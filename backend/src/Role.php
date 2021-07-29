<?php


namespace Src;


class Role
{

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }

    public function findAll()
    {
        $statement = "
            SELECT 
                *
            FROM
                roller;
        ";

        try {
            $statement = $this->db->query($statement);
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function find($rol_id)
    {
        $statement = "
            SELECT 
                *
            FROM
                roller
            WHERE rol_id = :rol_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rol_id' => $rol_id
            ));
            $result = $statement->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function insert(array $input)
    {
        $statement = "
            INSERT INTO roller 
                (rol_id, rol)
            VALUES
                (:rol_id, :rol);
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rol_id' => $input['rol_id'],
                'rol' => $input['rol']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function update($rol_id, array $input)
    {
        $statement = "
            UPDATE roller
            SET 
                rol = :rol
            WHERE rol_id = :rol_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'rol_id' => $rol_id,
                'rol' => $input['rol']
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }

    public function delete($rol_id)
    {
        $statement = "
            DELETE FROM roller
            WHERE rol_id = :rol_id;
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array('rol_id' => $rol_id));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }
    }
}